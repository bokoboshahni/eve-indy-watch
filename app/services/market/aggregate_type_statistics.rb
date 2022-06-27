# frozen_string_literal: true

class Market < ApplicationRecord
  class AggregateTypeStatistics < ApplicationService
    def initialize(market_id, type_id, start_time, end_time)
      super

      @market_id = market_id
      @type_id = type_id
      @start_time = start_time
      @end_time = end_time
    end

    def call # rubocop:disable Metrics/AbcSize
      snapshot_keys = markets_reader.zrangebyscore("#{market_key}.snapshots", start_time_key, end_time_key)
      type_keys = snapshot_keys.map { |k| "#{k}.types.#{type_id}.stats" }
      type_stats = markets_reader.mget(*type_keys).map { |json| Oj.load(json) }

      buy_price_min = type_stats.filter_map { |t| t.dig(:buy, :price_max) }.min
      buy_price_max = type_stats.filter_map { |t| t.dig(:buy, :price_max) }.max

      low_price = type_stats.filter_map { |t| t.dig(:sell, :price_min) }.min
      high_price = type_stats.filter_map { |t| t.dig(:sell, :price_min) }.max

      open_price = type_stats.first.dig(:sell, :price_min)
      close_price = type_stats.last.dig(:sell, :price_min)

      count = type_stats.sum { |t| [t.dig(:sell, :trade_count), t.dig(:buy, :trade_count)].compact.sum }
      volume = type_stats.sum { |t| [t.dig(:sell, :volume_traded), t.dig(:buy, :volume_traded)].compact.sum }

      {
        low: low_price,
        high: high_price,
        open: open_price,
        close: close_price,
        volume:,
        count:
      }
    end

    private

    attr_reader :market_id, :type_id, :start_time, :end_time

    def market_key
      "markets.#{market_id}"
    end

    def start_time_key
      start_time.to_formatted_s(:number)
    end

    def end_time_key
      end_time.to_formatted_s(:number)
    end
  end
end
