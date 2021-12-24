class Fitting < ApplicationRecord
  class CalculateAllStockLevelsWorker < ApplicationWorker
    def perform(interval = nil)
      time = Time.zone.now
      markets = Market.find(FittingMarket.distinct(:market_id).pluck(:market_id))
      args = markets.each_with_object([]) do |market, a|
        market_time = market.type_stats_updated_at
        jobs = market.fittings.pluck(:id).map { |fitting_id| [fitting_id, market.id, market_time, time, interval] }
        a.push(*jobs)
      end
      Fitting::CalculateStockLevelWorker.perform_bulk(args)
    end
  end
end
