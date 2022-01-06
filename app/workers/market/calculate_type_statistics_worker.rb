class Market < ApplicationRecord
  class CalculateTypeStatisticsWorker < ApplicationWorker
    def perform(market_id, type_ids, time)
      time = time.to_s.to_datetime
      type_ids.each do |type_id|
        Market::CalculateTypeStatistics.call(market_id, type_id, time)
      end
    end
  end
end
