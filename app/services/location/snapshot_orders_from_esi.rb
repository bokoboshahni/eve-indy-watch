# frozen_string_literal: true

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
      'duration' => 'd',
      'is_buy_order' => 's',
      'issued' => 'i',
      'location_id' => 'l',
      'min_volume' => 'vm',
      'order_id' => 'o',
      'price' => 'p',
      'range' => 'r',
      'system_id' => 'ss',
      'type_id' => 't',
      'volume_remain' => 'v',
      'volume_total' => 'vt'
    }.freeze

    METRIC_NAME = 'location/snapshot_orders_from_esi'

    attr_reader :location, :force, :page_count, :time, :batch, :expires, :etag, :orders_key, :orders_dir, :orders

    delegate :log_name, to: :location
    delegate :id, to: :location, prefix: true

    def fetch_page_count
      Retriable.retriable tries: 10 do
        req =  Typhoeus::Request.new(location_url, method: :head, headers:)
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
        @orders_key = "orders.#{location_id}.#{time.to_formatted_s(:number)}"
      end
    end

    def fetch_pages # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      duration = Benchmark.realtime do # rubocop:disable Metrics/BlockLength
        FileUtils.mkdir_p(orders_dir)

        pages = []
        pending_pages = page_count.times.to_a.map { |n| n + 1 }
        @orders = []

        fetch_duration = Benchmark.realtime do
          while pending_pages.any?
            pending_pages.each do |page|
              req = Typhoeus::Request.new(location_url, params: { page: }, headers: headers.merge(etag:))
              req.on_complete do |res|
                if res.code == 420
                  sleep(1)
                  next
                end

                next if res.code != 200

                next if /error/.match?(res.body)

                next if /\A50\d/.match?(res.body)

                next if res.body.strip.empty?

                orders.push(*Oj.load(res.body))
                pending_pages.delete(page)
              end
              hydra.queue(req)
            end
            hydra.run
          end
        end

        debug(
          "Fetched #{orders.count} order(s) from ESI for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/fetch",
          duration: fetch_duration * 1000
        )

        unique_orders = orders.uniq { |o| o['order_id'] }
                              .map! { |o| o.transform_keys! { |k| ORDER_KEYS[k] } }
                              .map! do |o|
          o['i'] = o['i'].to_datetime.to_i
          o
        end
        if unique_orders.any?
          expiry = app_config.order_snapshot_expiry.minutes.from_now.to_i
          measure_info( # rubocop:disable Metrics/BlockLength
            "Wrote #{unique_orders.count} order(s) to Redis for #{log_name} at #{log_time}",
            metric: "#{METRIC_NAME}/write_redis"
          ) do
            orders_writer.pipelined do |pipeline|
              order_set_count = unique_orders.group_by { |o| o['l'] }.each_with_object(0) do |(location_id, orders), c|
                pipeline.sadd("#{orders_key}.location_ids", location_id)

                orders.group_by { |o| o['t'] }.each do |(type_id, orders)|
                  pipeline.sadd("#{orders_key}.type_ids", type_id)

                  index_key = "#{'%019d' % location_id}:#{'%019d' % type_id}"

                  order_set_key = "#{orders_key}.orders.#{location_id}.#{type_id}"

                  pipeline.set(order_set_key, Oj.dump(orders))
                  pipeline.expireat(order_set_key, expiry)

                  pipeline.sadd("#{orders_key}.order_ids", orders.map { |o| o['o'] })
                  pipeline.zadd("#{orders_key}.order_set_keys_by_type", type_id, order_set_key)

                  pipeline.sadd("#{orders_key}.type_ids_by_location.#{location_id}", type_id)

                  c += 1
                end

                pipeline.expireat("#{orders_key}.type_ids_by_location.#{location_id}", expiry)
              end

              pipeline.expireat("#{orders_key}.location_ids", expiry)
              pipeline.expireat("#{orders_key}.order_ids", expiry)
              pipeline.expireat("#{orders_key}.order_set_keys_by_type", expiry)
              pipeline.expireat("#{orders_key}.type_ids", expiry)

              pipeline.set("#{orders_key}.order_set_count", order_set_count)
              pipeline.expireat("#{orders_key}.order_set_count", expiry)

              pipeline.zadd("orders.#{location_id}.snapshots", time_key, orders_key)
            end

            orders_writer.set("orders.#{location_id}.esi_last_modified", time.to_formatted_s(:number))
            orders_writer.set("orders.#{location_id}.esi_expires", expires.to_formatted_s(:number))
          end
        else
          debug("No orders for #{log_name} at #{log_time}")
        end

        next unless history_uploads_enabled?

        orders_file = "#{orders_dir}/#{time.to_formatted_s(:number)}.json"
        measure_debug(
          "Wrote #{unique_orders.count} order(s) to #{orders_file} for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/write_file"
        ) do
          File.write(orders_file, Oj.dump(unique_orders.map!(&:deep_stringify_keys!)))
        end

        orders_file_bz2 = "#{orders_file}.bz2"
        measure_debug(
          "Compressed #{orders_file} to #{orders_file_bz2} for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/compress_file"
        ) do
          cmd.run("bzip2 -q #{orders_file}", only_output_on_error: true)
        end

        history_path = "orders/#{location_id}/#{time.year}/#{time.month}/#{time.day}/#{File.basename(orders_file_bz2)}"
        measure_debug(
          "Uploaded #{orders_file_bz2} to #{history_path} for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/upload_file"
        ) do
          history_bucket.put_object(body: File.open(orders_file_bz2.to_s), key: history_path)
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
        raise Error, "#{location.class.name} #{log_name} has no ESI authorization" unless location.esi_authorized?

        esi_authorize!(location.esi_authorization)
        access_token = location.esi_authorization.access_token
        headers = headers.merge(Authorization: "Bearer #{access_token}") if location.is_a?(Structure)
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
      time.to_formatted_s(:number)
    end
  end
end
