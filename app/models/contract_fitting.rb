# frozen_string_literal: true

# ## Schema Information
#
# Table name: `contract_fittings`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`items`**        | `jsonb`            |
# **`quantity`**     | `integer`          | `not null`
# **`similarity`**   | `decimal(, )`      |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`contract_id`**  | `bigint`           | `not null, primary key`
# **`fitting_id`**   | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_contract_fittings_on_contract_id`:
#     * **`contract_id`**
# * `index_contract_fittings_on_fitting_id`:
#     * **`fitting_id`**
# * `index_unique_contract_fittings` (_unique_):
#     * **`contract_id`**
#     * **`fitting_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`contract_id => contracts.id`**
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
#
class ContractFitting < ApplicationRecord
  self.primary_keys = :contract_id, :fitting_id

  belongs_to :contract, inverse_of: :contract_fittings
  belongs_to :fitting, inverse_of: :contract_fittings

  scope :fully_matching, -> { where('quantity > 0') }
end
