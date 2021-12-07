# ## Schema Information
#
# Table name: `market_order_snapshots`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`duration`**              | `integer`          | `not null`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null, primary key`
# **`issued_at`**             | `datetime`         | `not null`
# **`kind`**                  | `text`             | `not null`
# **`location_type`**         | `string`           | `not null`
# **`min_volume`**            | `integer`          | `not null`
# **`price`**                 | `decimal(, )`      | `not null`
# **`range`**                 | `text`             | `not null`
# **`volume_remain`**         | `integer`          | `not null`
# **`volume_total`**          | `integer`          | `not null`
# **`location_id`**           | `bigint`           | `not null, primary key`
# **`order_id`**              | `bigint`           | `not null, primary key`
# **`solar_system_id`**       | `bigint`           | `not null`
# **`type_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_order_snapshots_on_location`:
#     * **`location_type`**
#     * **`location_id`**
# * `index_market_order_snapshots_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_market_order_snapshots_on_type_id`:
#     * **`type_id`**
# * `index_unique_market_order_snapshots` (_unique_):
#     * **`location_id`**
#     * **`order_id`**
#     * **`esi_last_modified_at`**
#
require 'rails_helper'

RSpec.describe MarketOrderSnapshot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
