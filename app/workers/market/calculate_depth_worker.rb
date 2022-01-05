class Market < ApplicationRecord
  class CalculateDepthWorker < ApplicationWorker
    def perform(market_id, time)
      Market.find(market_id).calculate_depth!(time.to_datetime)
    end
  end
end

