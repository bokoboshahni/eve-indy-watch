module Statistics
  class MarketTypeDailySummary < ApplicationRecord
    self.inheritance_column = nil
    self.table_name = :market_type_daily_summaries

    scope :for_week, -> (time) do
      where(bucket: time.at_beginning_of_week..time.at_end_of_week.at_beginning_of_day)
    end
  end
end
