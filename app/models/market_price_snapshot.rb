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
class MarketPriceSnapshot < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :type, inverse_of: :market_price_snapshots

  def self.sync_from_esi!
    MarketPriceSnapshot::SyncFromESI.call
  end
end
