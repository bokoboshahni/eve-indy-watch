# ## Schema Information
#
# Table name: `market_type_daily_summaries`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`bucket`**                     | `datetime`         |
# **`buy_order_count_avg`**        | `decimal(, )`      |
# **`buy_order_count_max`**        | `bigint`           |
# **`buy_order_count_min`**        | `bigint`           |
# **`buy_price_avg`**              | `decimal(, )`      |
# **`buy_price_max`**              | `decimal(, )`      |
# **`buy_price_min`**              | `decimal(, )`      |
# **`buy_sell_price_spread_avg`**  | `decimal(, )`      |
# **`buy_sell_price_spread_max`**  | `decimal(, )`      |
# **`buy_sell_price_spread_min`**  | `decimal(, )`      |
# **`buy_volume_max`**             | `bigint`           |
# **`buy_volume_min`**             | `bigint`           |
# **`buy_volume_sum_avg`**         | `decimal(, )`      |
# **`sell_order_count_avg`**       | `decimal(, )`      |
# **`sell_order_count_max`**       | `bigint`           |
# **`sell_order_count_min`**       | `bigint`           |
# **`sell_price_avg`**             | `decimal(, )`      |
# **`sell_price_max`**             | `decimal(, )`      |
# **`sell_price_min`**             | `decimal(, )`      |
# **`sell_volume_max`**            | `bigint`           |
# **`sell_volume_min`**            | `bigint`           |
# **`sell_volume_sum_avg`**        | `decimal(, )`      |
# **`market_id`**                  | `bigint`           |
# **`type_id`**                    | `bigint`           |
#
module Statistics
  class MarketTypeDailySummary < ApplicationRecord
    self.inheritance_column = nil
    self.table_name = :market_type_daily_summaries

    belongs_to :type, inverse_of: :market_daily_summaries

    scope :for_week, -> (time) do
      where(bucket: time.at_beginning_of_week..time.at_end_of_week.at_beginning_of_day)
    end

    scope :last_7_days, -> do
      where(bucket: 7.days.ago.beginning_of_day..Time.zone.now.at_beginning_of_day)
    end

    scope :by_market, -> id { where(market_id: id) }

    scope :by_market_and_type, -> (market_id, type_id) do
      where(market_id: market_id, type_id: type_id)
    end
  end
end
