# ## Schema Information
#
# Table name: `region_type_histories`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`average`**      | `decimal(, )`      | `not null`
# **`date`**         | `date`             | `not null, primary key`
# **`highest`**      | `decimal(, )`      | `not null`
# **`lowest`**       | `decimal(, )`      | `not null`
# **`order_count`**  | `bigint`           | `not null`
# **`volume`**       | `bigint`           | `not null`
# **`region_id`**    | `bigint`           | `not null, primary key`
# **`type_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_unique_region_type_histories` (_unique_):
#     * **`region_id`**
#     * **`type_id`**
#     * **`date`**
# * `region_type_histories_date_idx`:
#     * **`date`**
#
require 'rails_helper'

RSpec.describe Statistics::RegionTypeHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
