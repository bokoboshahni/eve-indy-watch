# frozen_string_literal: true

class Fitting < ApplicationRecord
  class CalculateStockLevelWorker < ApplicationWorker
    def perform(fitting_id, market_id, market_time, time, interval)
      Fitting::CalculateStockLevel.call(
        fitting_id, market_id,
        DateTime.parse(market_time), DateTime.parse(time), interval
      )
    end
  end
end
