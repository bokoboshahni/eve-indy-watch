class Market < ApplicationRecord
  class PruneTypeAggregationsWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(market_id, interval, prune_before)
      market = Market.find(market_id)
      market.prune_type_aggregations!(interval, prune_before)
    end
  end
end
