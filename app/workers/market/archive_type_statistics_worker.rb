# frozen_string_literal: true

class Market < ApplicationRecord
  class ArchiveTypeStatisticsWorker < ApplicationWorker
    sidekiq_options queue: :archive

    def perform(market_id, time)
      Market::ArchiveTypeStatistics.call(market_id, time.to_datetime)
    end
  end
end
