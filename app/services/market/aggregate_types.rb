class Market < ApplicationRecord
  class AggregateTypes < ApplicationService
    AGGREGATIONS = {
      order_count: ->(r) { r.count },
      price_avg: ->(r) { r.average(:price) },
      price_max: ->(r) { r.maximum(:price) },
      price_med: ->(r) { r.median(:price) },
      price_min: ->(r) { r.minimum(:price) },
      price_sum: ->(r) { r.sum(:price) },
      volume_avg: ->(r) { r.average(:volume_remain) },
      volume_max: ->(r) { r.maximum(:volume_remain) },
      volume_med: ->(r) { r.median(:volume_remain) },
      volume_min: ->(r) { r.minimum(:volume_remain) },
      volume_sum: ->(r) { r.sum(:volume_remain) }
    }

    def initialize(market, aggregation, interval)
      super

      @market = market
      @aggregation = aggregation.to_sym
      @interval = interval
    end

    def call
      location_ids = market.market_locations.pluck(:location_id)

      if interval == '15m'
        snapshots = MarketOrderSnapshot.where(location_id: location_ids).group(:kind, :type_id)
        snapshots.rollup(name, interval: interval, &AGGREGATIONS[aggregation])
      else
        rollups = Rollup.where(name: name, interval: ROLLUPS[interval]).group("dimensions->'kind'", "dimensions->'type_id'")
        rollups.rollup(name, interval: interval, &ROLLUP_AGGREGATIONS[aggregation])
      end
    end

    private

    ROLLUPS = {
      'hour' => '15m',
      'day' => 'hour',
      'week' => 'day',
      'month' => 'day',
      'quarter' => 'month'
    }

    ROLLUP_AGGREGATIONS = {
      order_count: ->(r) { r.average(:value) },
      price_avg: ->(r) { r.average(:value) },
      price_max: ->(r) { r.maximum(:value) },
      price_med: ->(r) { r.median(:value) },
      price_min: ->(r) { r.minimum(:value) },
      price_sum: ->(r) { r.average(:value) },
      volume_avg: ->(r) { r.average(:value) },
      volume_max: ->(r) { r.maximum(:value) },
      volume_med: ->(r) { r.median(:value) },
      volume_min: ->(r) { r.minimum(:value) },
      volume_sum: ->(r) { r.average(:value) }
    }

    attr_reader :aggregation, :interval, :market

    delegate :id, to: :market, prefix: true

    def name
      @name ||= "mkt_#{market_id}_types.#{aggregation}"
    end
  end
end
