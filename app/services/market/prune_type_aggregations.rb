class Market < ApplicationRecord
  class PruneTypeAggregations < ApplicationService
    def initialize(market, interval, prune_before)
      super

      @market = market
      @interval = interval
      @prune_before = prune_before
    end

    def call
      Market::AggregateTypes::AGGREGATIONS.each_key do |aggregation|
        name = "mkt_#{market_id}_types.#{aggregation}"
        Rollup.where(name: name, interval: interval).where('time <= ?', prune_before).delete_all
      end
    end

    private

    attr_reader :interval, :market, :prune_before

    delegate :id, to: :market, prefix: true
  end
end
