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
require 'rails_helper'

RSpec.describe ProcurementOrderItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
