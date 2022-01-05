# ## Schema Information
#
# Table name: `orders`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`duration`**         | `integer`          | `not null`
# **`is_buy_order`**     | `boolean`          | `not null`
# **`issued_at`**        | `datetime`         | `not null`
# **`min_volume`**       | `integer`          | `not null`
# **`price`**            | `decimal(15, 2)`   | `not null`
# **`range`**            | `enum`             | `not null`
# **`status`**           | `enum`             | `not null`
# **`volume_remain`**    | `integer`          | `not null`
# **`volume_total`**     | `integer`          | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`location_id`**      | `bigint`           | `not null`
# **`solar_system_id`**  | `bigint`           | `not null`
# **`type_id`**          | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_orders_on_location_id`:
#     * **`location_id`**
# * `index_orders_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_orders_on_type_id`:
#     * **`type_id`**
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
