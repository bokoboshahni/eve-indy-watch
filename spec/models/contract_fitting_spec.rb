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
require 'rails_helper'

RSpec.describe ContractFitting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
