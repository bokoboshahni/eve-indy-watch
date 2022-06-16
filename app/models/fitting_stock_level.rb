# frozen_string_literal: true

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
# **`interval`**                  | `enum`             | `not null, primary key`
# **`market_buy_price`**          | `decimal(, )`      |
# **`market_quantity`**           | `integer`          |
# **`market_sell_price`**         | `decimal(, )`      |
# **`market_time`**               | `datetime`         |
# **`reorder_point`**             | `integer`          |
# **`time`**                      | `datetime`         | `not null, primary key`
# **`fitting_id`**                | `bigint`           | `not null, primary key`
# **`market_id`**                 | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_fitting_stock_levels_on_fitting_id`:
#     * **`fitting_id`**
# * `index_fitting_stock_levels_on_market_id`:
#     * **`market_id`**
# * `index_unique_fitting_stock_levels` (_unique_):
#     * **`fitting_id`**
#     * **`market_id`**
#     * **`interval`**
#     * **`market_time DESC`**
#
class FittingStockLevel < ApplicationRecord
  include FittingStockLevelCalculations

  self.primary_keys = :fitting_id, :market_id, :interval, :time

  INTERVALS = %i[live end_of_day end_of_week end_of_month].freeze

  enum interval: INTERVALS.index_with(&:to_s)

  belongs_to :fitting, inverse_of: :stock_levels, touch: true
  belongs_to :market, inverse_of: :fitting_stock_levels

  has_many :items, class_name: 'FittingStockLevelItem', inverse_of: :stock_level,
                   foreign_key: %i[fitting_id market_id interval time], dependent: :destroy

  accepts_nested_attributes_for :items

  validates :interval, presence: true, inclusion: { in: intervals.keys }

  scope :last_7_days, -> { where(time: 7.days.ago.beginning_of_day..Time.zone.now.beginning_of_day) }
  scope :last_30_days, -> { where(time: 30.days.ago.beginning_of_day..Time.zone.now.beginning_of_day) }

  scope :by_fitting, ->(id) { where(fitting_id: id) }
  scope :by_market, ->(id) { where(market_id: id) }

  scope :by_fitting_and_market, ->(fitting_id, market_id) { where(fitting_id: fitting_id, market_id: market_id) }
end
