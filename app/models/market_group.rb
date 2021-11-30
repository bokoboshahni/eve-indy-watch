# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_groups`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`ancestry`**        | `text`             |
# **`ancestry_depth`**  | `integer`          |
# **`description`**     | `text`             | `not null`
# **`name`**            | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`parent_id`**       | `integer`          |
#
# ### Indexes
#
# * `index_market_groups_on_ancestry`:
#     * **`ancestry`**
#
class MarketGroup < ApplicationRecord
  has_ancestry cache_depth: true

  has_many :types, inverse_of: :market_group, dependent: :restrict_with_exception
end
