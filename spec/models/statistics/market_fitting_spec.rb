# ## Schema Information
#
# Table name: `market_fittings`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`items`**        | `jsonb`            |
# **`price_buy`**    | `decimal(, )`      |
# **`price_sell`**   | `decimal(, )`      |
# **`price_split`**  | `decimal(, )`      |
# **`quantity`**     | `integer`          |
# **`time`**         | `datetime`         | `not null, primary key`
# **`fitting_id`**   | `bigint`           | `not null, primary key`
# **`market_id`**    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `market_fittings_time_idx`:
#     * **`time`**
#
require 'rails_helper'

RSpec.describe Statistics::MarketFitting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
