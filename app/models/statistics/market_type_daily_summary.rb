module Statistics
  class MarketTypeDailySummary < ApplicationRecord
    self.inheritance_column = nil
    self.table_name = :market_type_daily_summaries

    scope :for_week, -> (time) do
      where(bucket: time.at_beginning_of_week..time.at_end_of_week.at_beginning_of_day)
    end

    scope :last_7_days, -> do
      where(bucket: 7.days.ago.beginning_of_day..Time.zone.now.at_beginning_of_day)
    end

    scope :by_market_and_type, -> (market_id, type_id) do
      where(market_id: market_id, type_id: type_id)
    end
  end
end
