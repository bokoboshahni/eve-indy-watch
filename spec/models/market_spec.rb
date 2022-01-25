# frozen_string_literal: true

# ## Schema Information
#
# Table name: `markets`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint`           | `not null, primary key`
# **`active`**                  | `boolean`          |
# **`archiving_enabled`**       | `boolean`          |
# **`name`**                    | `text`             | `not null`
# **`orders_updated_at`**       | `datetime`         |
# **`owner_type`**              | `string`           |
# **`private`**                 | `boolean`          |
# **`regional`**                | `boolean`          |
# **`trade_hub`**               | `boolean`          |
# **`type_stats_updated_at`**   | `datetime`         |
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
# **`owner_id`**                | `bigint`           |
# **`source_location_id`**      | `bigint`           |
# **`type_history_region_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_markets_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
# * `index_markets_on_source_location_id`:
#     * **`source_location_id`**
# * `index_markets_on_type_history_region_id`:
#     * **`type_history_region_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`type_history_region_id => regions.id`**
#
require 'rails_helper'

RSpec.describe Market, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
