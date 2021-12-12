class MarketFittingSnapshot < ApplicationRecord
  class CreateFromFittingAndMarketWorker < ApplicationWorker
    def perform(market_id, fitting_id, time)
      market = Market.find(market_id)
      fitting = Fitting.find(fitting_id)
      fitting.create_market_snapshot!(market, time)
    end
  end
end
