# frozen_string_literal: true

# ## Schema Information
#
# Table name: `procurement_orders`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`accepted_at`**                | `datetime`         |
# **`appraisal_url`**              | `text`             |
# **`bonus`**                      | `decimal(, )`      |
# **`delivered_at`**               | `datetime`         |
# **`discarded_at`**               | `datetime`         |
# **`estimated_completion_at`**    | `datetime`         |
# **`multiplier`**                 | `decimal(, )`      | `not null`
# **`notes`**                      | `text`             |
# **`published_at`**               | `datetime`         |
# **`requester_name`**             | `text`             |
# **`requester_type`**             | `string`           | `not null`
# **`split_fulfillment_enabled`**  | `boolean`          |
# **`status`**                     | `enum`             | `not null`
# **`supplier_name`**              | `text`             |
# **`supplier_type`**              | `string`           |
# **`target_completion_at`**       | `datetime`         |
# **`tracking_number`**            | `bigint`           |
# **`unconfirmed_at`**             | `datetime`         |
# **`visibility`**                 | `enum`             |
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`location_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
# **`supplier_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_procurement_orders_on_discarded_at`:
#     * **`discarded_at`**
# * `index_procurement_orders_on_location_id`:
#     * **`location_id`**
# * `index_procurement_orders_on_requester`:
#     * **`requester_type`**
#     * **`requester_id`**
# * `index_procurement_orders_on_supplier`:
#     * **`supplier_type`**
#     * **`supplier_id`**
#
require 'rails_helper'

RSpec.describe ProcurementOrder, type: :model do
end
