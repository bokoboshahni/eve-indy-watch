# frozen_string_literal: true

# ## Schema Information
#
# Table name: `contract_items`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`id`**            | `bigint`           | `not null, primary key`
# **`is_included`**   | `boolean`          | `not null`
# **`is_singleton`**  | `boolean`          | `not null`
# **`quantity`**      | `integer`          | `not null`
# **`raw_quantity`**  | `integer`          |
# **`created_at`**    | `datetime`         | `not null`
# **`updated_at`**    | `datetime`         | `not null`
# **`contract_id`**   | `bigint`           | `not null`
# **`type_id`**       | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_contract_items_on_contract_id`:
#     * **`contract_id`**
# * `index_contract_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`contract_id => contracts.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
require 'rails_helper'

RSpec.describe ContractItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
