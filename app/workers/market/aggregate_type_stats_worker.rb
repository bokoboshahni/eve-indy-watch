class Market < ApplicationRecord
  class AggregateTypeStatsWorker < ApplicationWorker
    def perform(market_id, time)
      time = DateTime.parse(time)
      Market.find(market_id).aggregate_type_stats!(time)
    end
  end
end
