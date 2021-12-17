# ## Schema Information
#
# Table name: `market_orders`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`duration`**         | `integer`          | `not null`
# **`issued_at`**        | `datetime`         | `not null`
# **`kind`**             | `text`             | `not null`
# **`location_type`**    | `string`           | `not null`
# **`min_volume`**       | `integer`          | `not null`
# **`price`**            | `decimal(, )`      | `not null`
# **`range`**            | `text`             | `not null`
# **`time`**             | `datetime`         | `not null, primary key`
# **`volume_remain`**    | `integer`          | `not null`
# **`volume_total`**     | `integer`          | `not null`
# **`batch_page_id`**    | `bigint`           | `is an Array`
# **`location_id`**      | `bigint`           | `not null, primary key`
# **`order_id`**         | `bigint`           | `not null, primary key`
# **`solar_system_id`**  | `bigint`           | `not null`
# **`type_id`**          | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_unique_market_orders` (_unique_):
#     * **`location_id`**
#     * **`order_id`**
#     * **`time`**
#
require 'rails_helper'

RSpec.describe MarketOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
