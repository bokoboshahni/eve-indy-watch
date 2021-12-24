# ## Schema Information
#
# Table name: `region_type_histories`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`average`**      | `decimal(, )`      | `not null`
# **`date`**         | `date`             | `not null`
# **`highest`**      | `decimal(, )`      | `not null`
# **`lowest`**       | `decimal(, )`      | `not null`
# **`order_count`**  | `bigint`           | `not null`
# **`volume`**       | `bigint`           | `not null`
# **`region_id`**    | `bigint`           | `not null`
# **`type_id`**      | `bigint`           | `not null`
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
module Statistics
  class RegionTypeHistory < ApplicationRecord
    self.table_name = :region_type_histories
  end
end
