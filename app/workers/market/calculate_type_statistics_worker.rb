# frozen_string_literal: true

class Market < ApplicationRecord
  class CalculateTypeStatisticsWorker < ApplicationWorker
    def perform(market_id, type_ids, time, force = false) # rubocop:disable Style/OptionalBooleanParameter
      time = time.to_s.to_datetime
      type_ids.each do |type_id|
        Market::CalculateTypeStatistics.call(market_id, type_id, time, force: force)
      rescue Redis::CommandError => e
        raise unless /mget/.match?(e.message)

        error("No order sets found for #{type_id} for #{market_id} at #{time.to_s(:db)}")
      end
    end
  end
end
