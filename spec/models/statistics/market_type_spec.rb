# ## Schema Information
#
# Table name: `market_types`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`buy_five_pct_order_count`**   | `bigint`           |
# **`buy_five_pct_price_avg`**     | `decimal(, )`      |
# **`buy_five_pct_price_med`**     | `decimal(, )`      |
# **`buy_price_avg`**              | `decimal(, )`      |
# **`buy_price_max`**              | `decimal(, )`      |
# **`buy_price_med`**              | `decimal(, )`      |
# **`buy_price_min`**              | `decimal(, )`      |
# **`buy_price_sum`**              | `decimal(, )`      |
# **`buy_sell_price_spread`**      | `decimal(, )`      |
# **`buy_total_order_count`**      | `bigint`           |
# **`buy_trimmed_order_count`**    | `bigint`           |
# **`buy_volume_avg`**             | `decimal(, )`      |
# **`buy_volume_max`**             | `bigint`           |
# **`buy_volume_med`**             | `bigint`           |
# **`buy_volume_min`**             | `bigint`           |
# **`buy_volume_sum`**             | `bigint`           |
# **`sell_five_pct_order_count`**  | `decimal(, )`      |
# **`sell_five_pct_price_avg`**    | `decimal(, )`      |
# **`sell_five_pct_price_med`**    | `decimal(, )`      |
# **`sell_price_avg`**             | `decimal(, )`      |
# **`sell_price_max`**             | `decimal(, )`      |
# **`sell_price_med`**             | `decimal(, )`      |
# **`sell_price_min`**             | `decimal(, )`      |
# **`sell_price_sum`**             | `decimal(, )`      |
# **`sell_total_order_count`**     | `bigint`           |
# **`sell_trimmed_order_count`**   | `bigint`           |
# **`sell_volume_avg`**            | `decimal(, )`      |
# **`sell_volume_max`**            | `bigint`           |
# **`sell_volume_med`**            | `bigint`           |
# **`sell_volume_min`**            | `bigint`           |
# **`sell_volume_sum`**            | `bigint`           |
# **`time`**                       | `datetime`         | `not null, primary key`
# **`market_id`**                  | `bigint`           | `not null, primary key`
# **`type_id`**                    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_market_types_on_market_id_and_type_id_and_time`:
#     * **`market_id`**
#     * **`type_id`**
#     * **`time DESC`**
# * `market_types_time_idx`:
#     * **`time`**
#
require 'rails_helper'

RSpec.describe Statistics::MarketType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
