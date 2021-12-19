class Appraisal < ApplicationRecord
  class GenerateItems < ApplicationService
    def initialize(items, market, time)
      super

      @items = items
      @market = market
      @time = time
    end

    def call
      items.each_with_object([]) do |(type_id, qty), a|
        a << stats.fetch(type_id, {}).merge(quantity: qty)
      end
    end

    private

    attr_reader :items, :market, :time

    def stats
      @stats ||= Statistics::MarketType.where(market_id: market.id, time: time, type_id: type_ids)
                                       .each_with_object({}) { |r, h| h[r.type_id] = r.attributes.symbolize_keys.except(:time, :market_id) }
    end

    def type_ids
      items.keys
    end
  end
end
