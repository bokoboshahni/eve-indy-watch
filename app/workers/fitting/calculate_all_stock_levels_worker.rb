# frozen_string_literal: true

class Fitting < ApplicationRecord
  class CalculateAllStockLevelsWorker < ApplicationWorker
    def perform(interval)
      time = Time.zone.now
      markets = Market.find(FittingMarket.distinct(:market_id).pluck(:market_id))
      args = markets.each_with_object([]) do |market, a|
        market_time = market.latest_snapshot_time

        unless market_time
          error "Market #{market.log_name} has no snapshot in Redis"
          next
        end

        jobs = market.fittings.with_inventory_tracking.pluck(:id).map { |fitting_id| [fitting_id, market.id, market_time, time, interval] }
        a.push(*jobs)
      end
      Fitting::CalculateStockLevelWorker.perform_bulk(args)
    end
  end
end
