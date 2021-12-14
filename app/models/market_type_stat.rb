# ## Schema Information
#
# Table name: `market_type_stats`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`buy_order_count`**   | `bigint`           |
# **`buy_price_avg`**     | `decimal(, )`      |
# **`buy_price_max`**     | `decimal(, )`      |
# **`buy_price_min`**     | `decimal(, )`      |
# **`buy_price_sum`**     | `decimal(, )`      |
# **`buy_volume_avg`**    | `decimal(, )`      |
# **`buy_volume_max`**    | `bigint`           |
# **`buy_volume_min`**    | `bigint`           |
# **`buy_volume_sum`**    | `bigint`           |
# **`sell_order_count`**  | `bigint`           |
# **`sell_price_avg`**    | `decimal(, )`      |
# **`sell_price_max`**    | `decimal(, )`      |
# **`sell_price_min`**    | `decimal(, )`      |
# **`sell_price_sum`**    | `decimal(, )`      |
# **`sell_volume_avg`**   | `decimal(, )`      |
# **`sell_volume_max`**   | `bigint`           |
# **`sell_volume_min`**   | `bigint`           |
# **`sell_volume_sum`**   | `bigint`           |
# **`time`**              | `datetime`         | `not null`
# **`market_id`**         | `bigint`           | `not null`
# **`type_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_type_stats_on_market_id`:
#     * **`market_id`**
# * `index_market_type_stats_on_type_id`:
#     * **`type_id`**
# * `index_unique_market_type_stats` (_unique_):
#     * **`market_id`**
#     * **`type_id`**
#     * **`time`**
# * `market_type_stats_time_idx`:
#     * **`time`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
class MarketTypeStat < ApplicationRecord
  belongs_to :market, inverse_of: :market_type_stats
  belongs_to :type, inverse_of: :market_type_stats
end
