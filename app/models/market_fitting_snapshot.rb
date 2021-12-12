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
# * `index_market_fitting_snapshots_on_market_id`:
#     * **`market_id`**
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
class MarketFittingSnapshot < ApplicationRecord
  self.primary_keys = :market_id, :fitting_id, :time
  self.rollup_column = :time

  belongs_to :market, inverse_of: :market_fitting_snapshots
  belongs_to :fitting, inverse_of: :market_fitting_snapshots

  def limiting_items
    @limiting_items ||=
      begin
        ids = items.each_with_object([]) { |(i, q), a| a << i if q.zero? }
        Type.find(ids)
      end
  end
end
