# frozen_string_literal: true

class Market < ApplicationRecord
  class AggregateFittingStats < ApplicationService
    def initialize(market, fitting, time)
      super

      @fitting = fitting
      @market = market
      @time = time
    end

    def call
      if Statistics::MarketFitting.exists?(fitting_id: fitting_id, market_id: market_id, time: time)
        warn("Market fitting entry already exists for #{fitting.log_name} in #{market.log_name} at #{time}")
        return
      end

      unless Statistics::MarketType.exists?(market_id: market_id, time: time)
        error("No type statistics available for #{market.log_name} at #{time}")
        return
      end

      match = fitting.match_market(market)
      mf = match.merge(fitting_id: fitting_id, market_id: market_id, time: time)

      if (match[:quantity]).positive?
        item_prices = fitting.compact_items.each_with_object({}) do |(item, qty), h|
          type = Type.find(item)

          h[item] = {}
          h[item][:buy] = type.market_buy_price(market) * qty.to_d
          h[item][:sell] = type.market_sell_price(market) * qty.to_d
          h[item][:split] = type.market_split_price(market) * qty.to_d
        end

        mf[:price_buy] = item_prices.values.map { |p| p[:buy] }.sum
        mf[:price_sell] = item_prices.values.map { |p| p[:sell] }.sum
        mf[:price_split] = item_prices.values.map { |p| p[:split] }.sum
      end

      Statistics::MarketFitting.create!(mf)
    end

    private

    attr_reader :fitting, :market, :time

    delegate :id, to: :fitting, prefix: true
    delegate :id, to: :market, prefix: true
  end
end
