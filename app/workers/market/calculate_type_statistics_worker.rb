class Market < ApplicationRecord
  class CalculateTypeStatisticsWorker < ApplicationWorker
    def perform(market_id, type_ids, time, force = false)
      time = time.to_s.to_datetime
      type_ids.each do |type_id|
        begin
          Market::CalculateTypeStatistics.call(market_id, type_id, time, force: force)
        rescue Redis::CommandError => e
          raise if e.message !~ /mget/
          error("No order sets found for #{type_id} for #{market_id} at #{time.to_s(:db)}")
        end
      end

      Market::PersistTypeStatisticsWorker.perform_async(market_id, type_ids, time.to_s(:number).to_i)
    end
  end
end
