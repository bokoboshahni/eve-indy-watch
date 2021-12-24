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
module Statistics
  class MarketFitting < ApplicationRecord
    self.primary_keys = :market_id, :fitting_id, :time
    self.table_name = :market_fittings

    belongs_to :market, inverse_of: :fitting_stats
    belongs_to :fitting, inverse_of: :market_stats

    validates :market_id, presence: true
    validates :fitting_id, presence: true
    validates :time, presence: true

    def limiting_items
      @limiting_items ||=
        begin
          ids = items.each_with_object([]) { |(i, q), a| a << i if q.zero? }
          ids.empty? ? [] : Type.find(ids)
        end
    end
  end
end
