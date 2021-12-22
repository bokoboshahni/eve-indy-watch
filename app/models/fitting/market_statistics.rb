class Fitting < ApplicationRecord
  module MarketStatistics
    extend ActiveSupport::Concern

    included do
      has_many :market_stats, class_name: 'Statistics::MarketFitting', inverse_of: :market
    end

    def latest_market_stats(market, scope = nil)
      @latest_market_stats ||= {}
      @latest_market_stats[market.id] ||= market_stats.find_by(market_id: market.id, time: market.orders_updated_at)
    end

    def market_on_hand(market)
      latest_market_stats(market)&.quantity
    end

    def market_price_buy(market)
      latest_market_stats(market)&.price_buy
    end

    def market_price_sell(market)
      latest_market_stats(market)&.price_sell
    end

    def market_price_split(market)
      latest_market_stats(market)&.price_split
    end

    def market_limiting_items(market)
      latest_market_stats(market)&.limiting_items
    end

    def match_market(market)
      MatchMarket.call(self, market)
    end
  end
end
