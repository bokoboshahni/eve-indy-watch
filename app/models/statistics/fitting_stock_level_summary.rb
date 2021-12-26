# ## Schema Information
#
# Table name: `fitting_stock_level_summaries`
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
# **`interval`**                  | `text`             | `not null, primary key`
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
# * `fitting_stock_level_summaries_time_idx`:
#     * **`time`**
# * `index_unique_fitting_stock_level_summaries` (_unique_):
#     * **`fitting_id`**
#     * **`market_id`**
#     * **`time DESC`**
#     * **`interval`**
#
module Statistics
  class FittingStockLevelSummary < ApplicationRecord
    self.primary_keys = :fitting_id, :market_id, :time, :interval
    self.table_name = :fitting_stock_level_summaries

    belongs_to :fitting, inverse_of: :stock_level_summaries
    belongs_to :market, inverse_of: :fitting_stock_level_summaries

    has_many :items, class_name: 'Statistics::FittingStockLevelSummaryItem', inverse_of: :fitting_stock_level,
                     foreign_key: %i[fitting_id market_id time interval], dependent: :destroy

    accepts_nested_attributes_for :items

    scope :end_of_day, -> { where(interval: 'daily') }
    scope :end_of_week, -> { where(interval: 'weekly') }
    scope :end_of_month, -> { where(interval: 'monthly') }

    scope :by_fitting, -> id { where(fitting_id: id) }
    scope :by_market, -> id { where(market_id: id) }
  end
end
