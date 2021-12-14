# frozen_string_literal: true

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
# * `index_market_order_snapshots_on_location_id_and_time`:
#     * **`location_id`**
#     * **`esi_last_modified_at`**
#
require 'rails_helper'

RSpec.describe MarketOrderSnapshot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
