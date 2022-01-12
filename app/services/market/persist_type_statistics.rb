class Market < ApplicationRecord
  class PersistTypeStatistics < ApplicationService
    def initialize(market_id, type_ids, time)
      super

      @market_id = market_id
      @type_ids = type_ids
      @time = time
    end

    def call
      stats_keys = type_ids.map { |t| "#{market_key}.types.#{t}.stats" }
      stats_json = markets_reader.mapped_mget(*stats_keys)
      stats = stats_json.map do |(key, json)|
        if json.nil?
          error("No type statistics at #{key} for #{market_id} at #{time.to_s(:db)}")
          next
        end

        Oj.load(json)
      end
      stats.compact!

      columns = MarketTypeStats.column_names.map(&:to_sym)

      records = stats.each_with_object([]) do |type_stats, a|
        buy_attrs = type_stats[:buy]&.transform_keys! { |k| :"buy_#{k}" } || {}
        sell_attrs = type_stats[:sell]&.transform_keys! { |k| :"sell_#{k}" } || {}

        record = {
          time: time,
          market_id: market_id,
          type_id: type_stats[:type_id],
          buy_sell_spread: type_stats[:buy_sell_spread],
          mid_price: type_stats[:mid_price],
          depth: type_stats[:depth],
          flow: type_stats[:flow]
        }.merge!(buy_attrs).merge!(sell_attrs)

        a << record.merge!(columns.each_with_object({}) { |k, h| h[k] = nil unless record.key?(k) })
      end

      import_duration = Benchmark.realtime do
        MarketTypeStats.import(records, raise_error: true, on_duplicate_key_ignore: true)
      end

      debug(
        "Persisted type statistics for #{type_ids.count} type(s) for market #{market_id} at #{time.to_s(:db)}",
        metric: METRIC_NAME, duration: import_duration * 1000.0
      )
    end

    private

    METRIC_NAME = 'market/persist_type_statistics'

    attr_reader :market_id, :type_ids, :time

    def market_key
      "markets.#{market_id}.#{time_key}"
    end

    def time_key
      time.to_s(:number)
    end
  end
end
