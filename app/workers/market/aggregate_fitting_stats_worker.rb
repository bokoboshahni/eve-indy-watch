# frozen_string_literal: true

class Market < ApplicationRecord
  class AggregateFittingStatsWorker < ApplicationWorker
    def perform(market_id, fitting_id, time)
      market = Market.find(market_id)
      fitting = Fitting.find(fitting_id)

      if Statistics::MarketFitting.exists?(fitting_id: fitting_id, market_id: market_id, time: time)
        debug("Market fitting entry already exists for #{fitting.log_name} in #{market.log_name} at #{time}")
        return
      end

      unless market.type_stats_updated_at
        debug("No type statistics available for #{market.log_name}")
        return
      end

      market.aggregate_fitting_stats!(fitting, time)
    end
  end
end
