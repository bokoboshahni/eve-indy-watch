# frozen_string_literal: true

# ## Schema Information
#
# Table name: `markets`
#
# ### Columns
#
# Name                         | Type               | Attributes
# ---------------------------- | ------------------ | ---------------------------
# **`id`**                     | `bigint`           | `not null, primary key`
# **`name`**                   | `text`             | `not null`
# **`orders_updated_at`**      | `datetime`         |
# **`owner_type`**             | `string`           |
# **`trade_hub`**              | `boolean`          |
# **`type_stats_updated_at`**  | `datetime`         |
# **`created_at`**             | `datetime`         | `not null`
# **`updated_at`**             | `datetime`         | `not null`
# **`owner_id`**               | `bigint`           |
#
# ### Indexes
#
# * `index_markets_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
#
class Market < ApplicationRecord
  include PgSearch::Model

  multisearchable against: %i[name owner_name]

  belongs_to :owner, polymorphic: true, optional: true

  has_many :alliances_as_appraisal_market, class_name: 'Alliance', inverse_of: :appraisal_market
  has_many :alliances_as_main_market, class_name: 'Alliance', inverse_of: :main_market
  has_many :market_locations, inverse_of: :market, dependent: :destroy
  has_many :orders, class_name: 'MarketOrder', through: :market_locations
  has_many :stations, through: :market_locations, source: :location, source_type: 'Station'
  has_many :structures, through: :market_locations, source: :location, source_type: 'Structure'
  has_many :types, through: :orders

  delegate :name, to: :owner, prefix: true, allow_nil: true

  validates :name, presence: true

  def latest_orders
    orders.where(time: orders.maximum(:time))
  end

  def type_ids_for_sale
    time = Statistics::MarketType.where(market_id: id).maximum(:time)
    Statistics::MarketType.distinct(:type_id).where(market_id: id).pluck(:type_id)
  end

  def aggregate_fitting_stats!(fitting, time)
    AggregateFittingStats.call(self, fitting, time)
  end

  def aggregate_fitting_stats_async(fitting, time)
    AggregateFittingStatsWorker.perform_async(id, fitting.id, time)
  end

  def aggregate_type_stats!(time)
    AggregateTypeStats.call(self, time)
  end

  def aggregate_type_stats_async(time)
    AggregateTypeStatsWorker.perform_async(id, time)
  end
end
