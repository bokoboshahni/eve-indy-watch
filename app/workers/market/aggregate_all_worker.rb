class Market < ApplicationRecord
  class AggregateAllWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(interval)
      Market.all.each do |market|
        Market::AggregateTypes::AGGREGATIONS.each_key do |aggregation|
          market.aggregate_types_async(aggregation, interval)
        end
      end
    end
  end
end
