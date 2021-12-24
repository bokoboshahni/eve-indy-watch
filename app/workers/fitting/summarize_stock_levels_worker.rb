class Fitting < ApplicationRecord
  class SummarizeStockLevelsWorker < ApplicationWorker
    def perform(market_id, market_time, interval)
      time = Time.zone.now

      args = Fitting.pluck(:id).map { |fitting_id| [market_id, market_time, time, interval] }
      Fitting::CalculateStockLevelWorker.perform_bulk(args)
    end
  end
end
