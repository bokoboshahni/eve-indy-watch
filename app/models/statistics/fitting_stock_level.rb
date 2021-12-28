# ## Schema Information
#
# Table name: `fitting_stock_levels`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`contract_match_quantity`**   | `integer`          |
# **`contract_match_threshold`**  | `decimal(, )`      |
# **`contract_price_avg`**        | `decimal(, )`      |
# **`contract_price_max`**        | `decimal(, )`      |
# **`contract_price_med`**        | `decimal(, )`      |
# **`contract_price_min`**        | `decimal(, )`      |
# **`contract_price_sum`**        | `decimal(, )`      |
# **`contract_similarity_avg`**   | `decimal(, )`      |
# **`contract_similarity_max`**   | `decimal(, )`      |
# **`contract_similarity_med`**   | `decimal(, )`      |
# **`contract_similarity_min`**   | `decimal(, )`      |
# **`contract_total_quantity`**   | `integer`          |
# **`market_buy_price`**          | `decimal(, )`      |
# **`market_quantity`**           | `integer`          |
# **`market_sell_price`**         | `decimal(, )`      |
# **`market_time`**               | `datetime`         |
# **`time`**                      | `datetime`         | `not null, primary key`
# **`fitting_id`**                | `bigint`           | `not null, primary key`
# **`market_id`**                 | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `fitting_stock_levels_time_idx`:
#     * **`time`**
# * `index_unique_fitting_stock_levels` (_unique_):
#     * **`fitting_id`**
#     * **`market_id`**
#     * **`time DESC`**
#
module Statistics
  class FittingStockLevel < ApplicationRecord
    include FittingStockLevelCalculations

    self.primary_keys = :fitting_id, :market_id, :time
    self.table_name = :fitting_stock_levels

    belongs_to :fitting, inverse_of: :stock_levels, touch: true, touch: true
    belongs_to :market, inverse_of: :fitting_stock_levels

    has_many :items, class_name: 'Statistics::FittingStockLevelItem', inverse_of: :fitting_stock_level,
                     foreign_key: %i[fitting_id market_id time], dependent: :destroy

    accepts_nested_attributes_for :items
  end
end
