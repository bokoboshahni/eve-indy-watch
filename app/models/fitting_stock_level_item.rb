# frozen_string_literal: true

# ## Schema Information
#
# Table name: `fitting_stock_level_items`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`fitting_quantity`**    | `integer`          |
# **`interval`**            | `enum`             | `not null, primary key`
# **`market_buy_price`**    | `decimal(, )`      |
# **`market_sell_price`**   | `decimal(, )`      |
# **`market_sell_volume`**  | `bigint`           |
# **`time`**                | `datetime`         | `not null, primary key`
# **`fitting_id`**          | `bigint`           | `not null, primary key`
# **`market_id`**           | `bigint`           | `not null, primary key`
# **`type_id`**             | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_fitting_stock_level_items_on_fitting_id`:
#     * **`fitting_id`**
# * `index_fitting_stock_level_items_on_market_id`:
#     * **`market_id`**
# * `index_fitting_stock_level_items_on_type_id`:
#     * **`type_id`**
# * `index_unique_fitting_stock_level_items` (_unique_):
#     * **`fitting_id`**
#     * **`market_id`**
#     * **`type_id`**
#     * **`interval`**
#     * **`time DESC`**
#
class FittingStockLevelItem < ApplicationRecord
  self.inheritance_column = nil
  self.primary_keys = :fitting_id, :market_id, :type_id, :interval, :time

  INTERVALS = %i[live end_of_day end_of_week end_of_month].freeze

  enum interval: INTERVALS.index_with(&:to_s)

  belongs_to :stock_level, class_name: 'FittingStockLevel', inverse_of: :items, foreign_key: %i[fitting_id market_id interval time]

  validates :interval, presence: true, inclusion: { in: intervals.keys }
end
