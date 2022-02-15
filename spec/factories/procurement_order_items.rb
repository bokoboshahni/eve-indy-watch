# frozen_string_literal: true

# ## Schema Information
#
# Table name: `procurement_order_items`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`accepted_at`**        | `datetime`         |
# **`bonus`**              | `decimal(, )`      |
# **`delivered_at`**       | `datetime`         |
# **`multiplier`**         | `decimal(, )`      | `not null`
# **`price`**              | `decimal(, )`      | `not null`
# **`quantity_received`**  | `bigint`           |
# **`quantity_required`**  | `bigint`           | `not null`
# **`status`**             | `enum`             | `default("available"), not null`
# **`supplier_name`**      | `text`             |
# **`supplier_type`**      | `string`           |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`order_id`**           | `bigint`           | `not null`
# **`supplier_id`**        | `bigint`           |
# **`type_id`**            | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_procurement_order_items_on_order_id`:
#     * **`order_id`**
# * `index_procurement_order_items_on_supplier`:
#     * **`supplier_type`**
#     * **`supplier_id`**
# * `index_procurement_order_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`order_id => procurement_orders.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
FactoryBot.define do
  factory :procurement_order_item do
    association :order, factory: :procurement_order
    association :type

    multiplier { 100.0 }
    price { Faker::Number.within(range: 0.01..10_000_000_000.0).round(2).to_s }
    quantity_required { Faker::Number.within(range: 1..100_000) }
  end
end
