class Market < ApplicationRecord
  class CalculateTypeStatistics < ApplicationService
    def initialize(market_id, type_id, time)
      super

      @market_id = market_id
      @type_id = type_id
      @time = time
    end

    def call
      if markets_writer.exists("#{type_key}.stats").to_i == 1
        debug("Market depth and order flow have already been calculated for #{log_name} at #{log_time}")
        return
      end

      duration = Benchmark.realtime do
        order_ids_duration = Benchmark.realtime do
          current_orders_key = "orders.#{source_location_id}.#{time_key}"
          previous_orders_key = orders_reader.zrevrangebyscore("orders.#{source_location_id}.snapshots", "(#{time_key}", "0", limit: [0, 1]).first

          if market_regional?
            current_orders_keys = orders_reader.zrangebyscore("#{current_orders_key}.order_set_keys_by_type", type_id, type_id)
            current_orders_json = orders_reader.mapped_mget(*current_orders_keys)
            @current_orders = current_orders_json.each_with_object({}) do |(key, json), h|
              h.merge!(Oj.load(json).each_with_object({}) { |o, h| h[o['o']] = o })
            end

            raise "No current orders for #{log_name} at #{log_time} from keys: #{current_orders_keys}" if current_orders.empty?

            previous_orders_keys = orders_reader.zrangebyscore("#{previous_orders_key}.order_set_keys_by_type", type_id, type_id)
            @previous_orders = previous_orders_keys.empty? ? {} : orders_reader.mget(*previous_orders_keys).each_with_object({}) do |json, h|
              h.merge!(Oj.load(json).each_with_object({}) { |o, h| h[o['o']] = o })
            end
          else
            current_orders_keys = market_location_ids.each_with_object({}) do |location_id, h|
              h[location_id] = "#{current_orders_key}.orders.#{location_id}.#{type_id}"
            end

            @current_orders = market_location_ids.each_with_object({}) do |location_id, h|
              orders_json = orders_reader.get(current_orders_keys[location_id])

              if orders_json.blank?
                # trace("No orders for #{orders_key} for #{log_name} at #{log_time}")
                next
              end

              h.merge!(Oj.load(orders_json).each_with_object({}) { |o, h| h[o['o']] = o })
            end

            raise "No current orders for #{log_name} at #{log_time} from keys: #{current_orders_keys}" if current_orders.empty?

            @previous_orders = previous_orders_key.nil? ? {} : market_location_ids.each_with_object({}) do |location_id, h|
              orders_key = "#{previous_orders_key}.orders.#{location_id}.#{type_id}"
              orders_json = orders_reader.get(orders_key)

              if orders_json.blank?
                debug("No orders for #{orders_key} for #{log_name} at #{log_time}")
                next
              end

              h.merge!(Oj.load(orders_json).each_with_object({}) { |o, h| h[o['o']] = o })
            end
          end
        end

        # debug(
        #   "Loaded #{current_order_ids.count} current order(s) and #{previous_order_ids.count} previous order(s) from Redis for #{log_name} at #{log_time}",
        #   metric: "#{METRIC_NAME}/load_orders", duration: order_ids_duration * 1000.0
        # )

        deleted_order_ids = previous_order_ids - current_order_ids
        @deleted_orders = previous_orders.slice(*deleted_order_ids)
        # debug("Found #{deleted_orders.count} deleted order(s) in current snapshot for #{log_name} at #{log_time}}")

        created_order_ids =  current_order_ids - previous_order_ids
        @created_orders = current_orders.slice(*created_order_ids)
        # debug("Found #{created_orders.count} created order(s) in current snapshot for #{log_name} at #{log_time}}")

        other_order_ids = current_order_ids - created_order_ids - deleted_order_ids
        @changed_orders = current_orders.slice(*other_order_ids).each_with_object({}) do |(id, co), h|
          po = previous_orders[id]

          next if co['v'] == po['v'] && co['p'] == po['p']

          h[id] = [po, co]
        end
        # debug("Found #{changed_orders.count} changed order(s) in current snapshot for #{log_name} at #{log_time}")

        dom_duration = Benchmark.realtime do
          @dom = current_orders.values.group_by { |o| o['s'] ? :buy : :sell }.each_with_object({}) do |(side, orders), h|
            threshold =
              case side
              when :buy
                orders.map { |o| o['p'] }.max * 0.1
              when :sell
                orders.map { |o| o['p'] }.min * 10.0
              end

            trimmed_orders =
              case side
              when :buy
                orders.reject { |o| o['p'] < threshold }
              when :sell
                orders.reject { |o| o['p'] > threshold }
              end

            trimmed_orders = trimmed_orders.sort_by! { |o| o['v'] }
            trimmed_prices = trimmed_orders.map { |o| o['p'] }
            trimmed_volumes = trimmed_orders.map { |o| o['v'] }

            five_pct_orders = trimmed_orders.take((trimmed_orders.count * 0.05 / 100.0).ceil)
            five_pct_prices = five_pct_orders.map { |o| o['p'] }
            five_pct_volumes = five_pct_orders.map { |o| o['v'] }

            outliers = orders.count - trimmed_orders.count

            depth = trimmed_orders.sort_by! { |o| o['p'] }.group_by { |o| o['p'] }.each_with_object({}) do |(price, orders), h|
              volume = orders.map { |o| o['v'] }.sum

              next unless volume.positive?

              h[price] = volume
            end

            h[side] = {
              depth: depth,
              price_5pct_avg: five_pct_prices.mean.round(2),
              price_5pct_max: five_pct_prices.max,
              price_5pct_med: five_pct_prices.median,
              price_5pct_min: five_pct_prices.min,
              price_5pct_count: five_pct_orders.count,
              price_5pct_sum: five_pct_prices.sum,
              price_avg: trimmed_prices.mean.round(2),
              price_max: trimmed_prices.max,
              price_med: trimmed_prices.median,
              price_min: trimmed_prices.min,
              price_stdev: trimmed_prices.stdev.round(3),
              price_sum: trimmed_prices.sum,
              outlier_count: outliers,
              outlier_threshold: threshold.round(2),
              order_count: trimmed_orders.count,
              volume_avg: trimmed_volumes.mean.round(2),
              volume_max: trimmed_volumes.max,
              volume_med: trimmed_volumes.median,
              volume_min: trimmed_volumes.min,
              volume_stdev: trimmed_volumes.stdev.round(3),
              volume_sum: trimmed_volumes.sum
            }
          end

          dom[:depth] = (Array(dom.dig(:buy, :depth)&.keys) + Array(dom.dig(:sell, :depth)&.keys)).compact.sort.each_with_object({}) do |price, dh|
            dh[price] = {
              buy: dom.dig(:buy, :depth, price),
              sell: dom.dig(:sell, :depth, price)
            }
          end

          if dom[:buy] && dom[:sell]
            dom[:buy_sell_spread] = dom[:sell][:price_min] - dom[:buy][:price_max]
            dom[:mid_price] = ([dom[:sell][:price_min], dom[:buy][:price_max]].sum / 2.0).round(2)
          end

          dom[:buy].delete(:depth) if dom[:buy]
          dom[:sell].delete(:depth) if dom[:sell]
        end

        # debug(
        #   "Calculated depth of market for #{current_orders.count} order(s) for #{log_name} at #{log_time}",
        #   metric: "#{METRIC_NAME}/dom", duration: dom_duration
        # )

        order_flow_duration = Benchmark.realtime do
          created_orders_by_side = created_orders.values.group_by { |o| o['s'] ? :buy : :sell }

          @order_flow = changed_orders.values.group_by { |(_, co)| co['s'] ? :buy : :sell }.each_with_object({}) do |(side, orders), h|
            orders.map! do |o|
              po, co = o

              co.merge('tr' => po['v'] - co['v'])
            end

            orders += created_orders_by_side.fetch(side, []).select { |o| o['v'] < o['vt'] }.map do |o|
              o.merge('tr' => o['vt'] - o['v'] )
            end

            trade_count = orders.count
            volume_traded = orders.map { |o| o['tr'] }

            levels = orders.sort_by! { |o| o['p'] }.group_by { |o| o['p'] }.each_with_object({}) do |(price, orders), h|
              h[price] = orders.map { |o| o['tr'] }.sum
            end

            h[side] = {
              levels: levels,
              trade_count: trade_count,
              volume_traded_avg: volume_traded.mean.round(2),
              volume_traded_max: volume_traded.max,
              volume_traded_med: volume_traded.median,
              volume_traded_min: volume_traded.min,
              volume_traded_stdev: volume_traded.stdev.round(3),
              volume_traded: volume_traded.sum
            }
          end

          order_flow[:levels] = (Array(order_flow.dig(:buy, :levels)&.keys) + Array(order_flow.dig(:sell, :levels)&.keys)).compact.sort.each_with_object({}) do |price, dh|
            dh[price] = {
              buy: order_flow.dig(:buy, :levels, price) || 0,
              sell: order_flow.dig(:sell, :levels, price) || 0
            }
          end

          order_flow[:buy].delete(:levels) if order_flow[:buy]
          order_flow[:sell].delete(:levels) if order_flow[:sell]
        end

        # debug(
        #   "Calculated order flow for #{order_flow[:levels].count} price levels from current snapshot for #{log_name} at #{log_time}",
        #   metric: "#{METRIC_NAME}/order_flow", duration: order_flow_duration * 1000.0
        # )

        redis_duration = Benchmark.realtime do
          markets_writer.pipelined do
            expiry = (1.day.from_now.beginning_of_day + 12.hours).to_i

            stats = {
              time: time.to_s(:number),
              type_id: type_id.to_i,
              depth: dom[:depth],
              flow: order_flow[:levels]
            }

            stats[:buy] = dom.fetch(:buy, {}).merge(order_flow.fetch(:buy, {}))
            stats[:sell] = dom.fetch(:sell, {}).merge(order_flow.fetch(:sell, {}))

            if dom[:buy]
              markets_writer.set("#{type_key}.buy_price", dom[:buy][:price_max])
              markets_writer.expireat("#{type_key}.buy_price", expiry)

              markets_writer.set("#{type_key}.buy_count", dom[:buy][:order_count])
              markets_writer.expireat("#{type_key}.buy_count", expiry)

              markets_writer.set("#{type_key}.buy_volume", dom[:buy][:volume_sum])
              markets_writer.expireat("#{type_key}.buy_volume", expiry)
            end

            if dom[:sell]
              markets_writer.set("#{type_key}.sell_price", dom[:sell][:price_min])
              markets_writer.expireat("#{type_key}.sell_price", expiry)

              markets_writer.set("#{type_key}.sell_count", dom[:sell][:order_count])
              markets_writer.expireat("#{type_key}.sell_count", expiry)

              markets_writer.set("#{type_key}.sell_volume", dom[:sell][:volume_sum])
              markets_writer.expireat("#{type_key}.sell_volume", expiry)
            end

            if dom[:buy] && dom[:sell]
              stats[:buy_sell_spread] = dom[:buy_sell_spread]
              markets_writer.set("#{type_key}.buy_sell_spread", dom[:buy_sell_spread])
              markets_writer.expireat("#{type_key}.buy_sell_spread", expiry)

              stats[:mid_price] = dom[:mid_price]
              markets_writer.set("#{type_key}.mid_price", dom[:mid_price])
              markets_writer.expireat("#{type_key}.mid_price", expiry)
            end

            markets_writer.set("#{type_key}.stats", Oj.dump(stats))
            markets_writer.expireat("#{type_key}.stats", expiry)

            markets_writer.sadd("markets.#{market_id}.#{time_key}.type_ids", type_id)
            markets_writer.zadd("markets.#{market_id}.type_stats.#{type_id}", time_key.to_i, "#{type_key}.stats")
          end
        end

        # debug(
        #   "Wrote depth of market and order flow for #{current_orders.count} order(s) to #{market_key}.#{type_id}.stats Redis for #{log_name} at #{log_time}",
        #   metric: "#{METRIC_NAME}/write_redis", duration: redis_duration
        # )
      end

      # debug("Calculated depth of market and order flow for #{log_name} at #{log_time}", metric: METRIC_NAME, duration: duration * 1000.0)
    end

    private

    METRIC_NAME = 'market/calculate_order_flow'

    attr_reader :market_id, :type_id, :time, :current_orders, :previous_orders, :current_order_ids_with_location, :previous_order_ids_with_location

    attr_reader :deleted_orders, :created_orders, :changed_orders

    attr_reader :order_flow, :dom

    def market_location_ids
      @market_location_ids ||= markets_reader.smembers("markets.#{market_id}.location_ids").map(&:to_i)
    end

    def source_location_id
      @source_location_id ||= markets_reader.get("markets.#{market_id}.source_location_id").to_i
    end

    def market_regional?
      @market_regional ||= markets_reader.get("markets.#{market_id}.kind") == 'regional'
    end

    def current_order_ids
      current_orders.keys
    end

    def previous_order_ids
      previous_orders.keys
    end

    def deleted_order_ids
      deleted_orders.keys
    end

    def created_order_ids
      created_orders.keys
    end

    def changed_order_ids
      changed_orders.keys
    end

    def market_key
      @market_key ||= "markets.#{market_id}.#{time_key}.types"
    end

    def type_key
      @type_key ||= "#{market_key}.#{type_id}"
    end

    def time_key
      time.to_s(:number)
    end

    def latest_key
      "markets.#{market_id}.types.latest"
    end

    def log_name
      "#{market_id}/#{type_id}"
    end

    def log_time
      time.to_s(:db)
    end
  end
end
