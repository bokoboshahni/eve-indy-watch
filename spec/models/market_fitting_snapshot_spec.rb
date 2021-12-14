# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_fitting_snapshots`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`items`**        | `jsonb`            | `not null`
# **`price_buy`**    | `decimal(, )`      |
# **`price_sell`**   | `decimal(, )`      |
# **`price_split`**  | `decimal(, )`      |
# **`quantity`**     | `integer`          | `not null`
# **`time`**         | `datetime`         | `not null, primary key`
# **`fitting_id`**   | `bigint`           | `not null, primary key`
# **`market_id`**    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_market_fitting_snapshots_on_fitting_id`:
#     * **`fitting_id`**
# * `index_unique_market_fitting_snapshots` (_unique_):
#     * **`market_id`**
#     * **`fitting_id`**
#     * **`time`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
#
require 'rails_helper'

RSpec.describe MarketFittingSnapshot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
