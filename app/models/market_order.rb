# ## Schema Information
#
# Table name: `market_orders`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`duration`**         | `integer`          | `not null`
# **`issued_at`**        | `datetime`         | `not null`
# **`kind`**             | `text`             | `not null`
# **`location_type`**    | `string`           | `not null`
# **`min_volume`**       | `integer`          | `not null`
# **`price`**            | `decimal(, )`      | `not null`
# **`range`**            | `text`             | `not null`
# **`time`**             | `datetime`         | `not null, primary key`
# **`volume_remain`**    | `integer`          | `not null`
# **`volume_total`**     | `integer`          | `not null`
# **`batch_page_id`**    | `bigint`           | `is an Array`
# **`location_id`**      | `bigint`           | `not null, primary key`
# **`order_id`**         | `bigint`           | `not null, primary key`
# **`solar_system_id`**  | `bigint`           | `not null`
# **`type_id`**          | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_orders_on_time`:
#     * **`time`**
# * `index_unique_market_orders` (_unique_):
#     * **`location_id`**
#     * **`order_id`**
#     * **`time`**
#
class MarketOrder < ApplicationRecord
  self.inheritance_column = nil
  self.primary_keys = :location_id, :order_id, :time

  belongs_to :location, polymorphic: true
  belongs_to :solar_system, inverse_of: :market_orders
  belongs_to :type, inverse_of: :market_orders

  def self.create_batch!(location)
    CreateBatch.call(location)
  end

  def self.prune!(before)
    Prune.call(before)
  end

  def self.purge!
    MarketOrder.delete_all
    MarketOrder::Batch.destroy_all
    Statistics::MarketType.delete_all
    Market.update_all(orders_updated_at: nil, type_stats_updated_at: nil)
    Region.update_all(esi_market_orders_expires_at: nil, esi_market_orders_last_modified_at: nil, orders_updated_at: nil)
    Structure.update_all(esi_market_orders_expires_at: nil, esi_market_orders_last_modified_at: nil, orders_updated_at: nil)
  end
end
