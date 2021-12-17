# frozen_string_literal: true

class MarketFittingSnapshot < ApplicationRecord
  class CreateFromFittingAndMarket < ApplicationService
    def initialize(fitting, market, time)
      super

      @fitting = fitting
      @market = market
      @time = time
    end

    def call
      if fitting.market_fitting_snapshots.exists?(market_id: market_id, time: time)
        debug("Market fitting snapshot already exists for #{market.log_name} at #{time}")
        return
      end

      match = fitting.match_market(market)
      snapshot = match.merge(fitting_id: fitting_id, market_id: market_id, time: time)

      if (match[:quantity]).positive?
        item_prices = fitting.compact_items.each_with_object({}) do |(item, qty), h|
          type = Type.find(item)

          h[item] = {}
          h[item][:buy] = type.market_buy_price(market) * qty.to_d
          h[item][:sell] = type.market_sell_price(market) * qty.to_d
          h[item][:split] = type.market_split_price(market) * qty.to_d
        end

        snapshot[:price_buy] = item_prices.values.map { |p| p[:buy] }.sum
        snapshot[:price_sell] = item_prices.values.map { |p| p[:sell] }.sum
        snapshot[:price_split] = item_prices.values.map { |p| p[:split] }.sum
      end

      MarketFittingSnapshot.import!(
        [snapshot],
        track_validation_failures: true,
        on_duplicate_key_update: { conflict_target: %i[fitting_id market_id time], columns: :all }
      )
    end

    private

    attr_reader :fitting, :market, :time

    delegate :id, to: :fitting, prefix: true
    delegate :id, to: :market, prefix: true
  end
end
