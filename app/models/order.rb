# ## Schema Information
#
# Table name: `orders`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`duration`**         | `integer`          | `not null`
# **`issued_at`**        | `datetime`         | `not null`
# **`min_volume`**       | `integer`          | `not null`
# **`price`**            | `decimal(15, 2)`   | `not null`
# **`range`**            | `enum`             | `not null`
# **`side`**             | `enum`             | `not null`
# **`status`**           | `enum`             | `not null`
# **`volume_remain`**    | `integer`          | `not null`
# **`volume_total`**     | `integer`          | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`location_id`**      | `bigint`           | `not null`
# **`region_id`**        | `bigint`           | `not null`
# **`solar_system_id`**  | `bigint`           | `not null`
# **`type_id`**          | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_orders_on_location_id`:
#     * **`location_id`**
# * `index_orders_on_region_id`:
#     * **`region_id`**
# * `index_orders_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_orders_on_type_id`:
#     * **`type_id`**
#
class Order < StatisticsRecord
  self.inheritance_column = nil

  enum side: { buy: 'buy', sell: 'sell' }
  enum range: %i[
    station
    region
    solarsystem
    1
    2
    3
    4
    5
    10
    20
    30
    40
  ].each_with_object({}) { |v, h| h[v] = v.to_s }
  enum status: { active: 'active', filled: 'filled', deleted: 'closed' }

  # has_many :events, class_name: 'OrderEvent', inverse_of: :order, dependent: :destroy

  scope :by_location, -> (ids) { where(location_id: ids) }
  scope :by_type, -> (ids) { where(type_id: ids) }
  scope :by_active, -> { where(status: :active) }
end
