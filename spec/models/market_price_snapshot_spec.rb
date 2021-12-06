# ## Schema Information
#
# Table name: `market_price_snapshots`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`adjusted_price`**        | `decimal(, )`      |
# **`average_price`**         | `decimal(, )`      |
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`type_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_market_price_snapshots_on_type_id`:
#     * **`type_id`**
# * `index_unique_market_price_snapshots` (_unique_):
#     * **`type_id`**
#     * **`esi_last_modified_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
require 'rails_helper'

RSpec.describe MarketPriceSnapshot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
