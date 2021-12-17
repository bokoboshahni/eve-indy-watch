# frozen_string_literal: true

class MarketFittingSnapshot < ApplicationRecord
  class CreateFromFittingAndMarketWorker < ApplicationWorker
    def perform(market_id, fitting_id, time)
      market = Market.find(market_id)
      fitting = Fitting.find(fitting_id)

      if fitting.market_fitting_snapshots.exists?(market_id: market_id, time: time)
        debug("Market fitting snapshot already exists for #{market.log_name} at #{time}")
        return
      end

      fitting.create_market_snapshot!(market, time)
    end
  end
end
