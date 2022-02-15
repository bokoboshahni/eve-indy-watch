# frozen_string_literal: true

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
# * `index_unique_market_price_snapshots` (_unique_):
#     * **`type_id`**
#     * **`esi_last_modified_at`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
FactoryBot.define do
  factory :market_price_snapshot do
  end
end
