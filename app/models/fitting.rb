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

  multisearchable against: %i[name owner_name type_name item_names], if: :kept?

  has_paper_trail

  belongs_to :owner, polymorphic: true
  belongs_to :type, inverse_of: :fittings

  has_many :items, class_name: 'FittingItem', inverse_of: :fitting, dependent: :destroy
  has_many :killmail_fittings, inverse_of: :fitting, dependent: :destroy

  has_many :contract_fittings, inverse_of: :fitting, dependent: :destroy

  has_many :contracts, through: :contract_fittings do
    def matching
      where('contract_fittings.quantity > 0')
    end

    def partially_matching
      where('contract_fittings.similarity >= 0.95 AND contract_fittings.similarity < 1.0')
    end

    def problematic
      where('contract_fittings.similarity >= 0.75 AND contract_fittings.similarity < 1.0')
    end

    def all_matching
      where('contract_fittings.similarity >= 0.75')
    end
  end

  has_many :killmails, through: :killmail_fittings do
    def likely_matching
      where('killmail_fittings.similarity >= 0.95 AND killmail_fittings.similarity < 1.0')
    end
  end

  accepts_nested_attributes_for :items, allow_destroy: true

  scope :pinned, -> { where(pinned: true) }

  delegate :appraisal_market, :main_market, :markets, to: :owner

  delegate :name, to: :owner, prefix: true
  delegate :name, to: :type, prefix: true

  def item_names
    items.includes(:type).pluck('types.name')
  end

  def latest_market_stats(market)
    @latest_market_stats ||= {}
    @latest_market_stats[market.id] ||=
      begin
        time = Statistics::MarketFitting.where(fitting_id: id, market_id: market.id).maximum(:time)
        Statistics::MarketFitting.find_by(fitting_id: id, market_id: market.id, time: time)
      end
  end

  def market_on_hand(market)
    latest_market_stats(market)&.quantity
  end

  def market_price_buy(market)
    latest_market_stats(market)&.price_buy
  end

  def market_price_sell(market)
    latest_market_stats(market)&.price_sell
  end

  def market_price_split(market)
    latest_market_stats(market)&.price_split
  end

  def market_limiting_items(market)
    latest_market_stats(market)&.limiting_items
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

  def contracts_on_hand
    contracts.where(id: contract_fittings.matching.outstanding.pluck(:contract_id))
  end

  def contracts_all_on_hand
    contracts.all_matching.outstanding
  end

  def contracts_received(period = nil)
    contracts.where(id: contract_fittings.matching.pluck(:contract_id), issued_at: build_period(period))
  end

  def contracts_sold(period = nil)
    contracts.finished.where(
      id: contract_fittings.matching.pluck(:contract_id),
      completed_at: build_period(period)
    )
  end

  def contracts_sell_through_rate(period = nil)
    (contracts_sold(build_period(period)).count.to_d / contracts_received(build_period(period)).count.to_d) * 100.0
  end

  def contract_quality
    return unless contracts.outstanding.count.positive?

    (contracts.matching.outstanding.count.to_d / contracts.outstanding.count.to_d) * 100.0
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

  def match_contract(contract)
    MatchContract.call(self, contract)
  end

  def match_market(market)
    MatchMarket.call(self, market)
  end

  def total_available
    (contracts_on_hand&.count).to_i + market_on_hand(main_market).to_i
  end

  def reorder_point
    safety_stock
  end
end
