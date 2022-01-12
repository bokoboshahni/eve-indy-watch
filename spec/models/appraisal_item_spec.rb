# frozen_string_literal: true

# ## Schema Information
#
# Table name: `appraisal_items`
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
# **`buy_sell_price_spread`**      | `decimal(, )`      | `not null`
# **`buy_total_order_count`**      | `bigint`           |
# **`buy_trimmed_order_count`**    | `bigint`           |
# **`buy_volume_avg`**             | `decimal(, )`      |
# **`buy_volume_max`**             | `bigint`           |
# **`buy_volume_med`**             | `bigint`           |
# **`buy_volume_min`**             | `bigint`           |
# **`buy_volume_sum`**             | `bigint`           |
# **`quantity`**                   | `bigint`           | `not null`
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
# **`appraisal_id`**               | `bigint`           | `not null, primary key`
# **`type_id`**                    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_appraisal_items_on_appraisal_id`:
#     * **`appraisal_id`**
# * `index_appraisal_items_on_type_id`:
#     * **`type_id`**
#
require 'rails_helper'

RSpec.describe AppraisalItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
