# frozen_string_literal: true

class Market < ApplicationRecord
  class CalculateTypeStatisticsCallback
    include ServiceHelpers

    def on_success(_status, params)
      market_id = params['market_id']
      time = params['time']

      markets_writer.zadd("markets.#{market_id}.snapshots", time.to_i, "markets.#{market_id}.#{time}")

      latest_key = "markets.#{market_id}.latest"
      markets_writer.set(latest_key, time) unless markets_writer.get(latest_key).to_i > time.to_i

      markets_writer.expireat("markets.#{market_id}.#{time}.type_ids",
                              (1.day.from_now.beginning_of_day + 12.hours).to_i)

      Market::ArchiveTypeStatistics.call(market_id, time.to_datetime)
    end
  end
end
