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
require 'rails_helper'

RSpec.describe Statistics::MarketTypeDailySummary, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
