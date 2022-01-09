require 'tempfile'

class Location < ApplicationRecord
  class SnapshotOrdersFromESI < ApplicationService
    def initialize(locatable, force: false)
      super

      @location = locatable
      @force = force
    end

    def call
      fetch_page_count

      current_expires = orders_writer.get("orders.#{location_id}.esi_expires")&.to_datetime
      if current_expires.to_i > time.to_i && !force
        debug("Orders have already been fetched for #{log_name} at #{time.to_s(:db)}")
        return orders_writer.get("orders.#{location_id}.esi_last_modified")&.to_datetime
      end

      fetch_pages

      orders.any? ? time : nil
    end

    private

    ORDER_KEYS = {
      'duration'      => 'd',
      'is_buy_order'  => 's',
      'issued'        => 'i',
      'location_id'   => 'l',
      'min_volume'    => 'vm',
      'order_id'      => 'o',
      'price'         => 'p',
      'range'         => 'r',
      'system_id'     => 'ss',
      'type_id'       => 't',
      'volume_remain' => 'v',
      'volume_total'  => 'vt'
    }

    METRIC_NAME = 'location/snapshot_orders_from_esi'

    attr_reader :location, :force, :page_count, :time, :batch, :expires, :etag, :orders_key, :orders_dir, :orders

    delegate :log_name, to: :location
    delegate :id, to: :location, prefix: true

    def fetch_page_count
      Retriable.retriable tries: 10 do
        req =  Typhoeus::Request.new(location_url, method: :head, headers: headers)
        req.on_headers do |response|
          raise "Request for HEAD #{location_url} failed" unless response.code == 200
        end

        resp = req.run

        headers = resp.headers
        @time = headers['last-modified'].to_datetime
        @expires = headers['expires'].to_datetime
        @etag = headers['etag']
        @page_count = headers['X-Pages'].to_i
        @orders_dir = Rails.root.join("tmp/orders/#{location_id}")
        @orders_key = "orders.#{location_id}.#{time.to_s(:number)}"
      end
    end

    def fetch_pages
      duration = Benchmark.realtime do
        FileUtils.mkdir_p(orders_dir)

        pages = []
        pending_pages = page_count.times.to_a.map { |n| n + 1 }
        @orders = []

        fetch_duration = Benchmark.realtime do
          while pending_pages.any? do
            pending_pages.each do |page|
              req = Typhoeus::Request.new(location_url, params: { page: page }, headers: headers.merge(etag: etag))
              req.on_complete do |res|
                if res.code == 420
                  sleep(1)
                  next
                end

                next if res.code != 200

                next if res.body =~ /error/

                next if res.body =~ /\A50\d/

                next if res.body.strip.empty?

                orders.push(*Oj.load(res.body))
                pending_pages.delete(page)
              end
              hydra.queue(req)
            end
            hydra.run
          end
        end

        info(
          "Fetched #{orders.count} order(s) from ESI for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/fetch",
          duration: fetch_duration * 1000
        )

        unique_orders = orders.uniq { |o| o['order_id'] }
                              .map! { |o| o.transform_keys! { |k| ORDER_KEYS[k] } }
                              .map! { |o| o['i'] = o['i'].to_datetime.to_i; o }
        if unique_orders.any?
          expiry = 15.minutes.from_now.to_i
          measure_info(
            "Wrote #{unique_orders.count} order(s) to Redis for #{log_name} at #{log_time}",
            metric: "#{METRIC_NAME}/write_redis"
          ) do
            orders_writer.pipelined do
              orders_by_location_and_type = unique_orders.group_by { |o| "#{'%019d' % o['l']}.#{'%019d' % o['t']}" }
              orders_by_location_and_type.each do |(key, orders)|
                location_id, type_id = key.split('.')

                order_set_key = "#{orders_key}.orders.#{location_id.to_i}.#{type_id.to_i}"

                orders_writer.set(order_set_key, Oj.dump(orders))
                orders_writer.expireat(order_set_key, expiry)

                orders_writer.sadd("#{orders_key}.location_ids", location_id.to_i)
                orders_writer.sadd("#{orders_key}.order_ids", orders.map { |o| o['o'] })
                orders_writer.zadd("#{orders_key}.order_ids_by_location_id_and_type_id", orders.map { |o| [0, [location_id, type_id, o['o']].join(':')] })
                orders_writer.zadd("#{orders_key}.order_set_keys_by_type", type_id.to_i, order_set_key)
                orders_writer.sadd("#{orders_key}.type_ids", type_id.to_i)
                orders_writer.sadd("#{orders_key}.type_ids_by_location.#{location_id.to_i}", type_id.to_i)
              end

              orders_writer.expireat("#{orders_key}.location_ids", expiry)
              orders_writer.expireat("#{orders_key}.order_ids", expiry)
              orders_writer.expireat("#{orders_key}.order_ids_by_location_id_and_type_id", expiry)
              orders_writer.expireat("#{orders_key}.order_set_keys_by_type", expiry)
              orders_writer.expireat("#{orders_key}.type_ids", expiry)

              orders_writer.expireat("#{orders_key}.type_ids_by_location", expiry)

              orders_writer.set("#{orders_key}.order_set_count", orders_by_location_and_type.count)
              orders_writer.expireat("#{orders_key}.order_set_count", expiry)

              orders_writer.zadd("orders.#{location_id}.snapshots", time_key, orders_key)
            end

            orders_writer.set("orders.#{location_id}.esi_last_modified", time.to_s(:number))
            orders_writer.set("orders.#{location_id}.esi_expires", expires.to_s(:number))
          end
        else
          logger.info("No orders for #{log_name} at #{log_time}")
        end

        orders_file = "#{orders_dir}/#{time.to_s(:number)}.json"
        measure_info(
          "Wrote #{unique_orders.count} order(s) to #{orders_file} for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/write_file"
        ) do
          File.write(orders_file, Oj.dump(unique_orders))
        end

        orders_file_bz2 = "#{orders_file}.bz2"
        measure_info(
          "Compressed #{orders_file} to #{orders_file_bz2} for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/compress_file"
        ) do
          cmd.run("bzip2 -q #{orders_file}", only_output_on_error: true)
        end

        history_path = "orders/#{location_id}/#{time.year}/#{time.month}/#{time.day}/#{File.basename(orders_file_bz2)}"
        measure_info(
          "Uploaded #{orders_file_bz2} to #{history_path} for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/upload_file"
        ) do
          history_bucket.put_object(body: File.open("#{orders_file_bz2}"), key: history_path)
        end

        FileUtils.rm_rf(orders_file_bz2)
      end

      info(
        "Snapshotted orders for #{log_name} at #{log_time}",
        metric: METRIC_NAME, duration: duration * 1000.0
      )
    end

    def headers
      headers = default_headers

      if location.is_a?(Structure)
        unless location.esi_authorized?
          raise Error, "#{location.class.name} #{log_name} has no ESI authorization"
        end

        esi_authorize!(location.esi_authorization)
        access_token = location.esi_authorization.access_token
        headers = headers.merge('Authorization': "Bearer #{access_token}") if location.is_a?(Structure)
      end

      headers
    end

    def location_url
      case location
      when Region
        "https://esi.evetech.net/latest/markets/#{location_id}/orders"
      when Structure
        "https://esi.evetech.net/latest/markets/structures/#{location_id}"
      end
    end

    def log_time
      time.to_s(:db)
    end

    def time_key
      time.to_s(:number)
    end
  end
end
