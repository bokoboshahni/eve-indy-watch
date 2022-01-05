require 'tempfile'

class Location < ApplicationRecord
  class SnapshotOrdersFromESI < ApplicationService
    def initialize(locatable)
      super

      @location = locatable
    end

    def call
      fetch_page_count

      unless orders_redis.get(latest_key).to_i < time_key.to_i
        debug("Orders have already been fetched for #{log_name} at #{time.to_s(:db)}")
        return
      end

      fetch_pages

      orders.any? ? time : nil
    end

    private

    METRIC_NAME = 'location/snapshot_orders_from_esi'

    attr_reader :location, :page_count, :time, :batch, :expires, :etag, :orders_key, :orders_dir, :orders

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
        @expires = headers['expires']
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
        if unique_orders.any?
          expiry = 1.hour.from_now.to_i
          measure_info(
            "Wrote #{unique_orders.count} order(s) to Redis for #{log_name} at #{log_time}",
            metric: "#{METRIC_NAME}/write_redis"
          ) do
            orders_redis.pipelined do
              order_ids = []
              location_order_ids = {}
              location_type_ids = {}
              type_ids = {}
              buy_order_ids = []
              sell_order_ids = []

              unique_orders.each do |order_data|
                order_id = order_data['order_id']
                order_location_id = order_data['location_id']
                order_type_id = order_data['type_id']
                order_side = order_data['is_buy_order'] ? 1 : 0

                order_location_id_p = "%019d" % order_location_id
                order_type_id_p = "%019d" % order_type_id

                orders_redis.set("#{orders_key}.orders_json.#{order_id}", Oj.dump(order_data))
                orders_redis.expireat("#{orders_key}.orders_json.#{order_id}", expiry)

                orders_redis.sadd("#{orders_key}.location_ids", order_location_id)
                orders_redis.sadd("#{orders_key}.type_ids", order_type_id)
                orders_redis.sadd("#{orders_key}.order_ids", order_id)
                orders_redis.zadd("#{orders_key}.order_ids_by_location_id", order_location_id, order_id)
                orders_redis.zadd("#{orders_key}.order_ids_by_type_id", order_type_id, order_id)
                orders_redis.zadd("#{orders_key}.order_ids_by_side", order_side, order_id)
                orders_redis.zadd("#{orders_key}.order_ids_by_location_id_and_type_id", 0, [order_location_id_p, order_type_id_p, order_id].join(':'))
                orders_redis.zadd("#{orders_key}.order_ids_by_location_id_and_type_id_and_side", 0, [order_location_id_p, order_type_id_p, order_side, order_id].join(':'))
                orders_redis.zadd("#{orders_key}.type_ids_by_location", order_location_id, order_type_id)
              end

              orders_redis.expireat("#{orders_key}.location_ids", expiry)
              orders_redis.expireat("#{orders_key}.type_ids", expiry)
              orders_redis.expireat("#{orders_key}.order_ids", expiry)
              orders_redis.expireat("#{orders_key}.order_ids_by_location_id", expiry)
              orders_redis.expireat("#{orders_key}.order_ids_by_type_id", expiry)
              orders_redis.expireat("#{orders_key}.order_ids_by_side", expiry)
              orders_redis.expireat("#{orders_key}.order_ids_by_location_id_and_type_id", expiry)
              orders_redis.expireat("#{orders_key}.order_ids_by_location_id_and_type_id_and_side", expiry)
              orders_redis.expireat("#{orders_key}.type_ids_by_location", expiry)

              orders_redis.zadd("orders.#{location_id}.snapshots", time_key, orders_key)
            end

            orders_redis.set(latest_key, time_key) if orders_redis.get(latest_key).to_i < time_key.to_i
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

    def location_list
      @location_list ||= Kredis.set("orders.location_ids", config: :orders)
    end

    def location_orders_list
      @location_orders_list ||= Kredis.list("orders.#{location_id}.snapshots", config: :orders)
    end

    def latest_key
      "orders.#{location_id}.latest"
    end

    def log_time
      time.to_s(:db)
    end

    def time_key
      time.to_s(:number)
    end

    def orders_redis
      @orders_redis ||= Kredis.redis(config: :orders)
    end
  end
end
