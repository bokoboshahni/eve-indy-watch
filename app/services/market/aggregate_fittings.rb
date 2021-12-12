# frozen_string_literal: true

class Market < ApplicationRecord
  class AggregateFittings < ApplicationService
    AGGREGATIONS = {
      quantity_avg: ->(r) { r.average(:quantity) },
      price_buy_avg: ->(r) { r.average(:price_buy) },
      price_buy_max: ->(r) { r.maximum(:price_buy) },
      price_buy_med: ->(r) { r.median(:price_buy) },
      price_buy_min: ->(r) { r.minimum(:price_buy) },
      price_sell_avg: ->(r) { r.average(:price_sell) },
      price_sell_max: ->(r) { r.maximum(:price_sell) },
      price_sell_med: ->(r) { r.median(:price_sell) },
      price_sell_min: ->(r) { r.minimum(:price_sell) },
      price_split_avg: ->(r) { r.average(:price_split) },
      price_split_max: ->(r) { r.maximum(:price_split) },
      price_split_med: ->(r) { r.median(:price_split) },
      price_split_min: ->(r) { r.minimum(:price_split) }
    }.freeze

    def initialize(market, aggregation, interval)
      super

      @market = market
      @aggregation = aggregation.to_sym
      @interval = interval
    end

    def call
      if interval == '15m'
        snapshots = MarketFittingSnapshot.where(market_id: market_id).group(:fitting_id)
        snapshots.rollup(name, interval: interval, &AGGREGATIONS[aggregation])
      else
        rollups = Rollup.where(name: name, interval: ROLLUPS[interval]).group("dimensions->'market_id'",
                                                                              "dimensions->'fitting_id'")
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
    }.freeze

    ROLLUP_AGGREGATIONS = {
      quantity_avg: ->(r) { r.average(:value) },
      price_buy_avg: ->(r) { r.average(:value) },
      price_buy_max: ->(r) { r.maximum(:value) },
      price_buy_med: ->(r) { r.median(:value) },
      price_buy_min: ->(r) { r.minimum(:value) },
      price_sell_avg: ->(r) { r.average(:value) },
      price_sell_max: ->(r) { r.maximum(:value) },
      price_sell_med: ->(r) { r.median(:value) },
      price_sell_min: ->(r) { r.minimum(:value) },
      price_split_avg: ->(r) { r.average(:value) },
      price_split_max: ->(r) { r.maximum(:value) },
      price_split_med: ->(r) { r.median(:value) },
      price_split_min: ->(r) { r.minimum(:value) }
    }.freeze

    attr_reader :aggregation, :interval, :market

    delegate :id, to: :market, prefix: true

    def name
      @name ||= "mkt_#{market_id}.fittings.#{aggregation}"
    end
  end
end
