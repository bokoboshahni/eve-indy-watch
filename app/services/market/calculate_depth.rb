require 'enumerable/statistics'

class Market < ApplicationRecord
  class CalculateDepth < ApplicationService
    def initialize(market, time)
      super

      @market = market
      @time = time
    end

    def call
      unless markets_redis.get(latest_key).to_i < time_key.to_i
        debug("Depth of market has already been calculated for #{log_name} at #{log_time}")
        return
      end

      duration = Benchmark.realtime do
        orders_duration = Benchmark.realtime do
          @orders = market.market_locations.each_with_object([]) do |l, a|
            orders_key = "orders.#{l.source_location_id}.#{time_key}"

            order_ids = orders_redis.zrangebyscore("#{orders_key}.order_ids_by_location_id", l.location_id, l.location_id)
            order_ids.each_slice(1000) do |batch|
              keys = batch.map { |id| "#{orders_key}.orders_json.#{id}" }
              orders_redis.mget(*keys).map { |o| Oj.load(o) }.each { |o| a << o }
            end
          end
        end

        info(
          "Loaded #{orders.count} order(s) from Redis for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/load_orders", duration: orders_duration * 1000.0
        )

        orders_by_type = orders.group_by { |o| o['type_id'] }
        measure_info(
          "Calculated depth of market for #{orders_by_type.keys.count} type(s) and #{orders.count} order(s) for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/aggregate"
        ) do
          @types = orders_by_type.each_with_object({}) do |(type_id, orders), h|
            h[type_id] = orders.group_by { |o| o['is_buy_order'] ? :buy : :sell }.each_with_object({}) do |(side, orders), h|
              threshold =
                case side
                when :buy
                  orders.map { |o| o['price'] }.max * 0.1
                when :sell
                  orders.map { |o| o['price'] }.min * 10.0
                end

              trimmed_orders =
                case side
                when :buy
                  orders.reject { |o| o['price'] < threshold }
                when :sell
                  orders.reject { |o| o['price'] > threshold }
                end

              trimmed_orders = trimmed_orders.sort_by! { |o| o['volume'] }
              trimmed_prices = trimmed_orders.map { |o| o['price'] }
              trimmed_volumes = trimmed_orders.map { |o| o['volume_remain'] }

              five_pct_orders = trimmed_orders.take((trimmed_orders.count * 0.05 / 100.0).ceil)
              five_pct_prices = five_pct_orders.map { |o| o['price'] }
              five_pct_volumes = five_pct_orders.map { |o| o['volume_remain'] }

              outliers = orders.count - trimmed_orders.count

              levels = trimmed_orders.sort_by! { |o| o['price'] }.group_by { |o| o['price'] }.each_with_object({}) do |(price, orders), h|
                volume = orders.map { |o| o['volume_remain'] }.sum

                next unless volume.positive?

                h[price] = volume
              end

              h[side] = {
                price_5pct_avg: five_pct_prices.mean.round(2),
                price_5pct_max: five_pct_prices.max,
                price_5pct_med: five_pct_prices.median,
                price_5pct_min: five_pct_prices.min,
                price_5pct_count: five_pct_orders.count,
                price_5pct_stdev: five_pct_prices.stdev.round(3),
                price_5pct_sum: five_pct_prices.sum,
                levels: levels,
                price_avg: trimmed_prices.mean.round(2),
                price_max: trimmed_prices.max,
                price_med: trimmed_prices.median,
                price_min: trimmed_prices.min,
                price_stdev: trimmed_prices.stdev.round(3),
                price_sum: trimmed_prices.sum,
                outlier_count: outliers,
                outlier_threshold: threshold,
                count: trimmed_orders.count,
                volume_avg: trimmed_volumes.mean.round(2),
                volume_max: trimmed_volumes.max,
                volume_med: trimmed_volumes.median,
                volume_min: trimmed_volumes.min,
                volume_stdev: trimmed_volumes.stdev.round(3),
                volume: trimmed_volumes.sum
              }

              h[side][:price] =
                case side
                when :buy
                  h[side][:price_max]
                when :sell
                  h[side][:price_min]
                end
            end

            depth = (Array(h[type_id].dig(:buy, :levels)&.keys) + Array(h[type_id].dig(:sell, :levels)&.keys)).compact.sort.each_with_object({}) do |price, dh|
              dh[price] = {
                buy: h[type_id].dig(:buy, :levels, price),
                sell: h[type_id].dig(:sell, :levels, price)
              }
            end
            h[type_id][:depth] = depth

            if h[type_id][:buy] && h[type_id][:sell]
              h[type_id][:buy_sell_spread] = h[type_id][:sell][:price_min] - h[type_id][:buy][:price_max]
              h[type_id][:mid_price] = ([h[type_id][:sell][:price_min], h[type_id][:buy][:price_max]].sum / 2.0).round(2)
            end
          end
        end

        measure_info(
          "Wrote depth of market for #{orders_by_type.keys.count} type(s) and #{orders.count} order(s) to Redis for #{log_name} at #{log_time}",
          metric: "#{METRIC_NAME}/write_redis"
        ) do
          markets_redis.pipelined do
            expiry = 1.day.from_now.to_i
            types.each do |(type_id, stats)|
              type_id_p = "%019d" % type_id

              markets_redis.sadd("#{market_key}.type_ids", type_id)

              type_key = "#{market_key}.types.#{type_id}"

              markets_redis.set("#{type_key}.stats_json", Oj.dump(stats))
              markets_redis.expireat("#{type_key}.stats_json", expiry)

              %i[buy sell].each do |side|
                next unless stats[side]

                %i[price volume count].each do |key|
                  markets_redis.set("#{type_key}.#{side}_price", stats[side][key])
                  markets_redis.expireat("#{type_key}.#{side}_price", expiry)
                end
              end

              if stats[:buy_sell_spread]
                markets_redis.set("#{type_key}.buy_sell_spread", stats[:buy_sell_spread])
                markets_redis.expireat("#{type_key}.buy_sell_spread", expiry)
              end

              if stats[:mid_price]
                markets_redis.set("#{type_key}.mid_price", stats[:mid_price])
                markets_redis.expireat("#{type_key}.mid_price", expiry)
              end
            end

            markets_redis.expireat("#{market_key}.type_ids", expiry)

            markets_redis.zadd("markets.#{market_id}.dom.snapshots", time_key, market_key)
          end

          markets_redis.set(latest_key, time_key) if markets_redis.get(latest_key).to_i < time_key.to_i
        end
      end

      info("Calculated depth of market for #{log_name} at #{log_time}", metric: METRIC_NAME)
    end

    private

    METRIC_NAME = 'market/calculate_depth'

    attr_reader :market, :time, :orders, :types

    delegate :log_name, to: :market
    delegate :id, :name, to: :market, prefix: true

    def market_key
      "markets.#{market_id}.#{time_key}.dom"
    end

    def time_key
      time.to_s(:number)
    end

    def latest_key
      "markets.#{market_id}.dom.latest"
    end

    def log_time
      time.to_s(:db)
    end

    def markets_redis
      Kredis.redis(config: :markets)
    end

    def orders_redis
      Kredis.redis(config: :orders)
    end
  end
end
