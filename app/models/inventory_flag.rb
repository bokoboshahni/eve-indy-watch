# frozen_string_literal: true

# ## Schema Information
#
# Table name: `inventory_flags`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`order`**       | `integer`          | `not null`
# **`text`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_inventory_flags_on_name`:
#     * **`name`**
#
class InventoryFlag < ApplicationRecord
  has_many :killmail_items, inverse_of: :flag
end
