# frozen_string_literal: true

class Market < ApplicationRecord
  class PersistTypeStatisticsWorker < ApplicationWorker
    def perform(market_id, type_ids, time)
      time = time.to_s.to_datetime
      Market::PersistTypeStatistics.call(market_id, type_ids, time)
    end
  end
end
