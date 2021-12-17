# ## Schema Information
#
# Table name: `market_order_batches`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `bigint`           | `not null, primary key`
# **`completed_at`**   | `datetime`         |
# **`location_type`**  | `string`           | `not null`
# **`status`**         | `text`             | `not null`
# **`time`**           | `datetime`         | `not null`
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`location_id`**    | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_order_batches_on_location`:
#     * **`location_type`**
#     * **`location_id`**
# * `index_unique_market_order_batches` (_unique_):
#     * **`location_id`**
#     * **`location_type`**
#     * **`time`**
#
require 'rails_helper'

RSpec.describe MarketOrderBatch, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
