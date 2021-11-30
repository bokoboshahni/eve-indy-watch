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
class ContractItem < ApplicationRecord
  belongs_to :contract, inverse_of: :items
  belongs_to :type, inverse_of: :contract_items

  delegate :name, to: :type
end
