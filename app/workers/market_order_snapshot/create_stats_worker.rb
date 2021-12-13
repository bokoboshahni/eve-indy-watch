class MarketOrderSnapshot < ApplicationRecord
  class CreateStatsWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(market_id, time)
      market = Market.find(market_id)
      market.create_stats!(time)
    end
  end
end
