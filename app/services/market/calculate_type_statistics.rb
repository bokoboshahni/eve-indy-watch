# frozen_string_literal: true

class Market < ApplicationRecord
  class CalculateTypeStatistics < ApplicationService
    def initialize(market_id, type_id, time, force: false)
      super

      @market_id = market_id
      @type_id = type_id
      @time = time
      @force = force
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return if markets_writer.exists("#{type_key}.stats").to_i == 1 && !force

      duration = Benchmark.realtime do # rubocop:disable Metrics/BlockLength
        current_orders_key = "orders.#{source_location_id}.#{time_key}"
        previous_orders_key = orders_reader.zrevrangebyscore("orders.#{source_location_id}.snapshots",
                                                             "(#{time_key}", '0', limit: [0, 1]).first

        if market_regional?
          current_orders_keys = orders_reader.zrangebyscore("#{current_orders_key}.order_set_keys_by_type", type_id,
                                                            type_id)
          current_orders_json = orders_reader.mapped_mget(*current_orders_keys)
          @current_orders = current_orders_json.each_with_object({}) do |(_key, json), h|
            h.merge!(Oj.load(json).index_by { |o| o['o'] })
          end

          raise "No current orders for #{log_name} at #{log_time} from keys: #{current_orders_keys}" if current_orders.empty?

          previous_orders_keys = orders_reader.zrangebyscore("#{previous_orders_key}.order_set_keys_by_type",
                                                             type_id, type_id)
          @previous_orders = if previous_orders_keys.empty?
                               {}
                             else
                               orders_reader.mget(*previous_orders_keys).each_with_object({}) do |json, h|
                                 h.merge!(Oj.load(json).index_by { |o| o['o'] })
                               end
                             end
        else
          current_orders_keys = market_location_ids.index_with do |location_id|
            "#{current_orders_key}.orders.#{location_id}.#{type_id}"
          end

          @current_orders = market_location_ids.each_with_object({}) do |location_id, h|
            orders_key = current_orders_keys[location_id]
            orders_json = orders_reader.get(orders_key)

            if orders_json.blank?
              error("No orders for #{orders_key} for #{log_name} at #{log_time}")
              next
            end

            h.merge!(Oj.load(orders_json).index_by { |o| o['o'] })
          end

          raise "No current orders for #{log_name} at #{log_time} from keys: #{current_orders_keys}" if current_orders.empty?

          @previous_orders = if previous_orders_key.nil?
                               {}
                             else
                               market_location_ids.each_with_object({}) do |location_id, h|
                                 orders_key = "#{previous_orders_key}.orders.#{location_id}.#{type_id}"
                                 orders_json = orders_reader.get(orders_key)

                                 if orders_json.blank?
                                   debug("No orders for #{orders_key} for #{log_name} at #{log_time}")
                                   next
                                 end

                                 h.merge!(Oj.load(orders_json).index_by do |o|
                                            o['o']
                                          end)
                               end
                             end
        end

        deleted_order_ids = previous_order_ids - current_order_ids
        @deleted_orders = previous_orders.slice(*deleted_order_ids)

        created_order_ids = current_order_ids - previous_order_ids
        @created_orders = current_orders.slice(*created_order_ids)

        other_order_ids = current_order_ids - created_order_ids - deleted_order_ids
        @changed_orders = current_orders.slice(*other_order_ids).each_with_object({}) do |(id, co), h|
          po = previous_orders[id]

          next if co['v'] == po['v'] && co['p'] == po['p']

          h[id] = [po, co]
        end

        @dom = current_orders.values.group_by do |o| # rubocop:disable Metrics/BlockLength
                 o['s'] ? :buy : :sell
               end.each_with_object({}) do |(side, orders), h|
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

          depth = trimmed_orders.sort_by! do |o|
                    o['p']
                  end.group_by { |o| o['p'] }.each_with_object({}) do |(price, orders), h|
            volume = orders.sum { |o| o['v'] }

            next unless volume.positive?

            h[price] = volume
          end

          h[side] = {
            depth:,
            five_pct_price_avg: five_pct_prices.mean.round(2),
            five_pct_price_max: five_pct_prices.max,
            five_pct_price_med: five_pct_prices.median,
            five_pct_price_min: five_pct_prices.min,
            five_pct_price_sum: five_pct_orders.sum { |o| o['p'] * o['v'] },
            five_pct_order_count: five_pct_orders.count,
            price_avg: trimmed_prices.mean.round(2),
            price_max: trimmed_prices.max,
            price_med: trimmed_prices.median,
            price_min: trimmed_prices.min,
            price_sum: trimmed_orders.sum { |o| o['p'] * o['v'] },
            outlier_count: outliers,
            outlier_threshold: threshold.round(2),
            order_count: trimmed_orders.count,
            volume_avg: trimmed_volumes.mean.round(2),
            volume_max: trimmed_volumes.max,
            volume_med: trimmed_volumes.median,
            volume_min: trimmed_volumes.min,
            volume_sum: trimmed_volumes.sum
          }
        end

        dom[:depth] = (Array(dom.dig(:buy, :depth)&.keys) + Array(dom.dig(:sell, :depth)&.keys)).compact.sort.index_with do |price|
          {
            buy: dom.dig(:buy, :depth, price),
            sell: dom.dig(:sell, :depth, price)
          }
        end

        if dom[:buy] && dom[:sell]
          dom[:buy_sell_spread] = (dom[:sell][:price_min] - dom[:buy][:price_max]).round(2)
          dom[:mid_price] = ([dom[:sell][:price_min], dom[:buy][:price_max]].sum / 2.0).round(2)
        end

        dom[:buy]&.delete(:depth)
        dom[:sell]&.delete(:depth)

        created_orders_by_side = created_orders.values.group_by { |o| o['s'] ? :buy : :sell }

        @order_flow = changed_orders.values.group_by do |(_, co)|
                        co['s'] ? :buy : :sell
                      end.each_with_object({}) do |(side, orders), h|
          orders.map! do |o|
            po, co = o

            co.merge('tr' => po['v'] - co['v'])
          end

          orders += created_orders_by_side.fetch(side, []).select { |o| o['v'] < o['vt'] }.map do |o|
            o.merge('tr' => o['vt'] - o['v'])
          end

          trade_count = orders.count
          volume_traded = orders.map { |o| o['tr'] }

          levels = orders.sort_by! { |o| o['p'] }.group_by { |o| o['p'] }.transform_values do |orders|
            orders.sum { |o| o['tr'] }
          end

          h[side] = {
            levels:,
            trade_count:,
            volume_traded_avg: volume_traded.mean.round(2),
            volume_traded_max: volume_traded.max,
            volume_traded_med: volume_traded.median,
            volume_traded_min: volume_traded.min,
            volume_traded_sum: volume_traded.sum
          }
        end

        order_flow[:levels] = (Array(order_flow.dig(:buy, :levels)&.keys) + Array(order_flow.dig(:sell, :levels)&.keys)).compact.sort.index_with do |price|
          {
            buy: order_flow.dig(:buy, :levels, price) || 0,
            sell: order_flow.dig(:sell, :levels, price) || 0
          }
        end

        order_flow[:buy]&.delete(:levels)
        order_flow[:sell]&.delete(:levels)

        markets_writer.pipelined do |pipeline| # rubocop:disable Metrics/BlockLength
          expiry = app_config.market_snapshot_expiry.minutes.from_now.to_i

          stats = {
            time: time.to_formatted_s(:number),
            type_id: type_id.to_i,
            depth: dom[:depth],
            flow: order_flow[:levels]
          }

          stats[:buy] = dom.fetch(:buy, {}).merge(order_flow.fetch(:buy, {}))
          stats[:sell] = dom.fetch(:sell, {}).merge(order_flow.fetch(:sell, {}))

          if dom[:buy]
            pipeline.set("#{type_key}.buy_price", dom[:buy][:price_max])
            pipeline.expireat("#{type_key}.buy_price", expiry)

            pipeline.set("#{type_key}.buy_count", dom[:buy][:order_count])
            pipeline.expireat("#{type_key}.buy_count", expiry)

            pipeline.set("#{type_key}.buy_volume", dom[:buy][:volume_sum])
            pipeline.expireat("#{type_key}.buy_volume", expiry)
          end

          if dom[:sell]
            pipeline.set("#{type_key}.sell_price", dom[:sell][:price_min])
            pipeline.expireat("#{type_key}.sell_price", expiry)

            pipeline.set("#{type_key}.sell_count", dom[:sell][:order_count])
            pipeline.expireat("#{type_key}.sell_count", expiry)

            pipeline.set("#{type_key}.sell_volume", dom[:sell][:volume_sum])
            pipeline.expireat("#{type_key}.sell_volume", expiry)
          end

          if dom[:buy] && dom[:sell]
            stats[:buy_sell_spread] = dom[:buy_sell_spread]
            pipeline.set("#{type_key}.buy_sell_spread", dom[:buy_sell_spread])
            pipeline.expireat("#{type_key}.buy_sell_spread", expiry)

            stats[:mid_price] = dom[:mid_price]
            pipeline.set("#{type_key}.mid_price", dom[:mid_price])
            pipeline.expireat("#{type_key}.mid_price", expiry)
          end

          pipeline.set("#{type_key}.stats", Oj.dump(stats))
          pipeline.expireat("#{type_key}.stats", expiry)

          pipeline.sadd("markets.#{market_id}.#{time_key}.type_ids", type_id)
          pipeline.expireat("markets.#{market_id}.#{time_key}.type_ids", expiry)

          pipeline.incr("markets.#{market_id}.#{time_key}.type_count")
          pipeline.expireat("markets.#{market_id}.#{time_key}.type_count", expiry)

          pipeline.incrby("markets.#{market_id}.#{time_key}.order_count", current_orders.count)
          pipeline.expireat("markets.#{market_id}.#{time_key}.order_count", expiry)
        end
      end

      # debug("Calculated market statistics for #{log_name} at #{log_time}", metric: METRIC_NAME, duration: duration * 1000.0)
    end

    private

    METRIC_NAME = 'market/calculate_type_statistics'

    attr_reader :market_id, :type_id, :time, :force, :current_orders, :previous_orders,
                :current_order_ids_with_location, :previous_order_ids_with_location, :deleted_orders, :created_orders, :changed_orders, :order_flow, :dom

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
      time.to_formatted_s(:number)
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
