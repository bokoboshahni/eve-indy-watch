# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_locations`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`location_type`**       | `string`           | `not null, primary key`
# **`created_at`**          | `datetime`         | `not null`
# **`updated_at`**          | `datetime`         | `not null`
# **`location_id`**         | `bigint`           | `not null, primary key`
# **`market_id`**           | `bigint`           | `not null, primary key`
# **`source_location_id`**  | `bigint`           |
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
  belongs_to :source_location, class_name: 'Location', optional: true
  belongs_to :market, inverse_of: :market_locations

  delegate :name, to: :location, prefix: true
  delegate :orders_updated_at, to: :location

  def orders
    if location.is_a?(Station) || (location.is_a?(Structure) && !location.market_order_sync_enabled?)
      location.region.market_orders.where(location_id: location_id)
    else
      location.market_orders
    end
  end
end
