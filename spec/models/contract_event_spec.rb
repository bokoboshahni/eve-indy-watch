# frozen_string_literal: true

# ## Schema Information
#
# Table name: `contract_events`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`collateral`**      | `decimal(, )`      |
# **`event`**           | `text`             | `not null`
# **`price`**           | `decimal(, )`      |
# **`reward`**          | `decimal(, )`      |
# **`time`**            | `datetime`         | `not null`
# **`alliance_id`**     | `bigint`           |
# **`contract_id`**     | `bigint`           | `not null`
# **`corporation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_contract_events_on_alliance_id`:
#     * **`alliance_id`**
# * `index_contract_events_on_contract_id`:
#     * **`contract_id`**
# * `index_contract_events_on_corporation_id`:
#     * **`corporation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`contract_id => contracts.id`**
# * `fk_rails_...`:
#     * **`corporation_id => corporations.id`**
#
require 'rails_helper'

RSpec.describe ContractEvent, type: :model do
end
