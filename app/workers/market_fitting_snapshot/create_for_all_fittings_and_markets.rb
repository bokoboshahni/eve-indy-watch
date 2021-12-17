# frozen_string_literal: true

class MarketFittingSnapshot < ApplicationRecord
  class CreateForAllFittingsAndMarkets < ApplicationWorker
    def perform
      time = Time.zone.now
      Alliance.includes(:fittings).find_each do |alliance|
        markets = Market.where(owner_id: nil).or(Market.where(owner_id: alliance.id))

        args = markets.each_with_object([]) do |market, a|
          time = market.type_stats_updated_at
          alliance.fitting_ids.each do |fitting_id|
            existing_snapshot = MarketFittingSnapshot.exists?(market_id: market.id, fitting_id: fitting_id, time: time)
            a << [market.id, fitting_id, time] unless existing_snapshot
          end
        end
        MarketFittingSnapshot::CreateFromFittingAndMarketWorker.perform_bulk(args)
      end
    end
  end
end
