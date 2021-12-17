# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_locations`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`location_type`**  | `string`           | `not null, primary key`
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`location_id`**    | `bigint`           | `not null, primary key`
# **`market_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_market_locations_on_location`:
#     * **`location_type`**
#     * **`location_id`**
# * `index_market_locations_on_market_id`:
#     * **`market_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
#
class MarketLocation < ApplicationRecord
  self.primary_keys = :market_id, :location_type, :location_id

  belongs_to :location, polymorphic: true
  belongs_to :market, inverse_of: :market_locations

  has_many :orders, class_name: 'MarketOrder', inverse_of: :market_locations, primary_key: :location_id, foreign_key: :location_id
end
