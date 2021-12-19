# frozen_string_literal: true

# ## Schema Information
#
# Table name: `types`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`description`**      | `text`             |
# **`name`**             | `text`             | `not null`
# **`packaged_volume`**  | `decimal(, )`      |
# **`portion_size`**     | `integer`          |
# **`published`**        | `boolean`          |
# **`volume`**           | `decimal(, )`      |
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`group_id`**         | `bigint`           | `not null`
# **`market_group_id`**  | `bigint`           |
#
# ### Indexes
#
# * `index_types_on_group_id`:
#     * **`group_id`**
# * `index_types_on_market_group_id`:
#     * **`market_group_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`group_id => groups.id`**
# * `fk_rails_...`:
#     * **`market_group_id => market_groups.id`**
#
class Type < ApplicationRecord
  include PgSearch::Model

  multisearchable against: %i[description name market_group_name category_name group_name]

  belongs_to :group, inverse_of: :types
  belongs_to :market_group, inverse_of: :types, optional: true

  has_one :category, through: :group
  has_one :latest_market_price_snapshot, lambda {
                                           order esi_last_modified_at: :desc
                                         }, class_name: 'MarketPriceSnapshot', foreign_key: :type_id

  has_many :appraisal_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :contract_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :fitting_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :fittings, inverse_of: :type, dependent: :restrict_with_exception
  has_many :killmail_attacker_ships, inverse_of: :ship_type, dependent: :restrict_with_exception
  has_many :killmail_attacker_weapons, inverse_of: :weapon_type, dependent: :restrict_with_exception
  has_many :killmail_items, inverse_of: :type, dependent: :restrict_with_exception
  has_many :lossmails, class_name: 'Killmail', inverse_of: :ship_type, dependent: :restrict_with_exception
  has_many :market_price_snapshots, inverse_of: :type, dependent: :destroy
  has_many :stations, inverse_of: :type, dependent: :restrict_with_exception
  has_many :structures, inverse_of: :type, dependent: :restrict_with_exception

  delegate :name, to: :category, prefix: true
  delegate :name, to: :group, prefix: true
  delegate :name, to: :market_group, prefix: true, allow_nil: true

  delegate :adjusted_price, :average_price, to: :latest_market_price_snapshot

  def charge?
    category_name == Category::CHARGE_CATEGORY_NAME
  end

  def drone?
    category_name == Category::DRONE_CATEGORY_NAME
  end

  def fighter?
    category_name == Category::FIGHTER_CATEGORY_NAME
  end

  def module?
    Category::MODULE_CATEGORY_NAMES.include?(category_name)
  end

  def market_stat(market, stat)
    @market_stat ||= {}
    @market_stat["#{market.id}_#{stat}"] ||= Statistics::MarketType.find_by(
      market_id: market.id,
      type_id: id,
      time: Statistics::MarketType.where(market_id: market.id, type_id: id).maximum(:time)
    )&.send(stat) || 0.0
  end

  Statistics::MarketType.column_names.excluding('market_id', 'type_id', 'time').each do |stat|
    define_method "market_#{stat}" do |market|
      market_stat(market, stat)
    end
  end

  def market_buy_price(market)
    market_stat(market, :buy_price_max)
  end

  def market_sell_price(market)
    market_stat(market, :sell_price_min)
  end

  def market_split_price(market)
    (market_buy_price(market) + market_sell_price(market)) / 2.0
  end

  def market_volume(market)
    market_stat(market, :sell_volume_sum)
  end

  def icon_url
    "https://images.evetech.net/types/#{id}/icon"
  end

  def render_url
    "https://images.evetech.net/types/#{id}/render"
  end
end
