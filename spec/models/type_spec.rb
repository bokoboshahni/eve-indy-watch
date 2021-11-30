# frozen_string_literal: true

# ## Schema Information
#
# Table name: `types`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`description`**      | `text`             |
# **`name`**             | `text`             | `not null`
# **`packaged_volume`**  | `decimal(, )`      |
# **`portion_size`**     | `integer`          |
# **`published`**        | `boolean`          |
# **`volume`**           | `decimal(, )`      |
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`group_id`**         | `bigint`           | `not null`
# **`market_group_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_types_on_group_id`:
#     * **`group_id`**
# * `index_types_on_market_group_id`:
#     * **`market_group_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`group_id => groups.id`**
# * `fk_rails_...`:
#     * **`market_group_id => market_groups.id`**
#
require 'rails_helper'

RSpec.describe Type, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
