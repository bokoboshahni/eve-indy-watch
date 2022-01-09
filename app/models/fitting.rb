# frozen_string_literal: true

# ## Schema Information
#
# Table name: `fittings`
#
# ### Columns
#
# Name                            | Type               | Attributes
# ------------------------------- | ------------------ | ---------------------------
# **`id`**                        | `bigint`           | `not null, primary key`
# **`contract_match_threshold`**  | `decimal(, )`      |
# **`discarded_at`**              | `datetime`         |
# **`killmail_match_threshold`**  | `decimal(, )`      |
# **`name`**                      | `text`             | `not null`
# **`original`**                  | `text`             |
# **`owner_type`**                | `string`           | `not null`
# **`pinned`**                    | `boolean`          |
# **`safety_stock`**              | `integer`          |
# **`created_at`**                | `datetime`         | `not null`
# **`updated_at`**                | `datetime`         | `not null`
# **`owner_id`**                  | `bigint`           | `not null`
# **`type_id`**                   | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_fittings_on_discarded_at`:
#     * **`discarded_at`**
# * `index_fittings_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
# * `index_fittings_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
class Fitting < ApplicationRecord
  include Discard::Model
  include PgSearch::Model

  include ContractStatistics
  include KillmailStatistics
  include MarketStatistics

  SERVICE_LEVELS = [
    '50',
  ]

  multisearchable against: %i[name owner_name type_name item_names], if: :kept?

  has_paper_trail

  belongs_to :owner, polymorphic: true
  belongs_to :type, inverse_of: :fittings

  has_many :fitting_markets, inverse_of: :fitting
  has_many :items, class_name: 'FittingItem', inverse_of: :fitting, dependent: :destroy
  has_many :types, through: :items
  has_many :markets, through: :fitting_markets
  has_many :stock_level_summaries, class_name: 'Statistics::FittingStockLevelSummary', inverse_of: :fitting
  has_many :stock_levels, class_name: 'Statistics::FittingStockLevel', inverse_of: :fitting

  accepts_nested_attributes_for :items, allow_destroy: true

  scope :pinned, -> { where(pinned: true) }

  delegate :appraisal_market, :main_market, :markets, to: :owner

  delegate :name, to: :owner, prefix: true
  delegate :name, to: :type, prefix: true

  def current_stock_level_time(market)
    @current_stock_level_time ||= {}
    @current_stock_level_time[market.id] ||= stock_levels.where(market_id: market.id).maximum(:time)
  end

  def current_stock_level(market)
    @current_stock_level ||= {}
    @current_stock_level[market.id] ||= stock_levels.find_by(market_id: market.id, time: current_stock_level_time(market))
  end

  def type_ids
    [items.pluck(:type_id), type_id].flatten
  end

  def item_names
    items.includes(:type).pluck('types.name')
  end

  def compact_items
    all_items = items.select(:type_id, :quantity).each_with_object({}) do |item, h|
      type_id = item.type_id
      if h.key?(type_id)
        h[type_id] += item.quantity
      else
        h[type_id] = item.quantity
      end
    end
    all_items[type_id] = 1
    all_items
  end

  def compact_items_with_types
    grouped = items.includes(:type).order('types.name').each_with_object({}) do |item, h|
      type_id = item.type_id

      if h.key?(type_id)
        h[type_id][:quantity] += item.quantity
      else
        h[type_id] = { type: item.type, quantity: item.quantity }
      end
    end
    grouped.values
  end

  def build_period(period = nil)
    return default_period unless period

    case period
    when :week
      7.days.ago.beginning_of_day..Time.zone.now
    when :month
      30.days.ago.beginning_of_day..Time.zone.now
    else
      period
    end
  end

  def default_period
    30.days.ago.beginning_of_day..Time.zone.now
  end

  def total_available
    [
      contracts_on_hand&.count,
      market_on_hand(main_market),
    ].compact.sum
  end

  def reorder_point
    [
      safety_stock,
      lead_time_demand
    ].compact.sum
  end

  def regional_sales_daily_avg(period = nil)
    return 0.0 unless main_market.type_history_region

    type.regional_sales_daily_avg(main_market.type_history_region, period)
  end

  def demand_daily_avg(period = nil)
    all_demand = [
      contracts_sold_daily_avg(period),
      killmail_losses_daily_avg(period),
    ]
    all_demand << regional_sales_daily_avg(period)
    all_demand.compact.sum
  end

  def lead_time_demand(period = nil)
    (type.lead_time_days * demand_daily_avg(period)).round
  end

  def calculate_stock_level(market, market_time, time, interval = nil)
    CalculateStockLevel.call(id, market.id, market_time, time, interval)
  end
end
