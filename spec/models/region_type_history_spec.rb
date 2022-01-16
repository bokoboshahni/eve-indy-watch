# frozen_string_literal: true

# ## Schema Information
#
# Table name: `region_type_histories`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`average`**      | `decimal(, )`      |
# **`date`**         | `date`             | `not null, primary key`
# **`highest`**      | `decimal(, )`      |
# **`lowest`**       | `decimal(, )`      |
# **`order_count`**  | `bigint`           |
# **`volume`**       | `bigint`           |
# **`region_id`**    | `bigint`           | `not null, primary key`
# **`type_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_region_type_histories_on_region_id`:
#     * **`region_id`**
# * `index_region_type_histories_on_type_id`:
#     * **`type_id`**
# * `index_unique_region_type_histories` (_unique_):
#     * **`region_id`**
#     * **`type_id`**
#     * **`date`**
#
require 'rails_helper'

RSpec.describe RegionTypeHistory, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
