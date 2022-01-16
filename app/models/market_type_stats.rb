# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_type_stats`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`buy_five_pct_order_count`**   | `integer`          |
# **`buy_five_pct_price_avg`**     | `decimal(, )`      |
# **`buy_five_pct_price_max`**     | `decimal(, )`      |
# **`buy_five_pct_price_med`**     | `decimal(, )`      |
# **`buy_five_pct_price_min`**     | `decimal(, )`      |
# **`buy_five_pct_price_sum`**     | `decimal(, )`      |
# **`buy_order_count`**            | `integer`          |
# **`buy_outlier_count`**          | `integer`          |
# **`buy_outlier_threshold`**      | `decimal(, )`      |
# **`buy_price_avg`**              | `decimal(, )`      |
# **`buy_price_max`**              | `decimal(, )`      |
# **`buy_price_med`**              | `decimal(, )`      |
# **`buy_price_min`**              | `decimal(, )`      |
# **`buy_price_sum`**              | `decimal(, )`      |
# **`buy_sell_spread`**            | `decimal(, )`      |
# **`buy_trade_count`**            | `integer`          |
# **`buy_volume_avg`**             | `decimal(, )`      |
# **`buy_volume_max`**             | `bigint`           |
# **`buy_volume_med`**             | `bigint`           |
# **`buy_volume_min`**             | `bigint`           |
# **`buy_volume_sum`**             | `bigint`           |
# **`buy_volume_traded_avg`**      | `decimal(, )`      |
# **`buy_volume_traded_max`**      | `bigint`           |
# **`buy_volume_traded_med`**      | `bigint`           |
# **`buy_volume_traded_min`**      | `bigint`           |
# **`buy_volume_traded_sum`**      | `bigint`           |
# **`depth`**                      | `jsonb`            |
# **`flow`**                       | `jsonb`            |
# **`mid_price`**                  | `decimal(, )`      |
# **`sell_five_pct_order_count`**  | `integer`          |
# **`sell_five_pct_price_avg`**    | `decimal(, )`      |
# **`sell_five_pct_price_max`**    | `decimal(, )`      |
# **`sell_five_pct_price_med`**    | `decimal(, )`      |
# **`sell_five_pct_price_min`**    | `decimal(, )`      |
# **`sell_five_pct_price_sum`**    | `decimal(, )`      |
# **`sell_order_count`**           | `integer`          |
# **`sell_outlier_count`**         | `integer`          |
# **`sell_outlier_threshold`**     | `decimal(, )`      |
# **`sell_price_avg`**             | `decimal(, )`      |
# **`sell_price_max`**             | `decimal(, )`      |
# **`sell_price_med`**             | `decimal(, )`      |
# **`sell_price_min`**             | `decimal(, )`      |
# **`sell_price_sum`**             | `decimal(, )`      |
# **`sell_trade_count`**           | `integer`          |
# **`sell_volume_avg`**            | `decimal(, )`      |
# **`sell_volume_max`**            | `bigint`           |
# **`sell_volume_med`**            | `bigint`           |
# **`sell_volume_min`**            | `bigint`           |
# **`sell_volume_sum`**            | `bigint`           |
# **`sell_volume_traded_avg`**     | `decimal(, )`      |
# **`sell_volume_traded_max`**     | `bigint`           |
# **`sell_volume_traded_med`**     | `bigint`           |
# **`sell_volume_traded_min`**     | `bigint`           |
# **`sell_volume_traded_sum`**     | `bigint`           |
# **`time`**                       | `datetime`         | `not null, primary key`
# **`market_id`**                  | `bigint`           | `not null, primary key`
# **`type_id`**                    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_market_type_stats` (_unique_):
#     * **`market_id`**
#     * **`type_id`**
#     * **`time DESC`**
# * `market_type_stats_time_idx`:
#     * **`time`**
#
class MarketTypeStats < ApplicationRecord
  self.inheritance_column = nil
  self.primary_keys = :market_id, :type_id, :time

  belongs_to :market
  belongs_to :type
end
