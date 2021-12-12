class Market < ApplicationRecord
  class PruneAllTypeAggregationsWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(interval)
      Market.all.each do |market|
        case interval
        when '15m'
          Market::PruneTypeAggregationsWorker.perform_async(market.id, '15m', 1.day.ago.end_of_day)
        when 'hour'
          Market::PruneTypeAggregationsWorker.perform_async(market.id, 'hour', 8.days.ago.end_of_day)
        end
      end
    end
  end
end
