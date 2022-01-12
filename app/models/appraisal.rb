# frozen_string_literal: true

# ## Schema Information
#
# Table name: `appraisals`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`appraisable_type`**  | `string`           |
# **`code`**              | `text`             | `not null`
# **`description`**       | `text`             |
# **`expires_at`**        | `datetime`         |
# **`market_time`**       | `datetime`         | `not null`
# **`original`**          | `text`             |
# **`price_modifier`**    | `decimal(, )`      |
# **`price_period`**      | `text`             | `not null`
# **`price_stat`**        | `text`             | `not null`
# **`price_type`**        | `text`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`appraisable_id`**    | `bigint`           |
# **`market_id`**         | `bigint`           | `not null`
# **`user_id`**           | `bigint`           |
#
# ### Indexes
#
# * `index_appraisals_on_appraisable`:
#     * **`appraisable_type`**
#     * **`appraisable_id`**
# * `index_appraisals_on_code` (_unique_):
#     * **`code`**
# * `index_appraisals_on_market_id`:
#     * **`market_id`**
# * `index_appraisals_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#
class Appraisal < ApplicationRecord
  PRICE_PERIODS = %w[immediate].freeze
  PRICE_TYPES = %w[buy sell split].freeze
  PRICE_STATS = %w[five_pct_price_avg five_pct_price_med avg min med max].freeze

  DEFAULT_PRICE_PERIOD = 'immediate'
  DEFAULT_PRICE_TYPE = 'sell'
  DEFAULT_PRICE_STAT = 'min'

  belongs_to :appraisable, polymorphic: true, optional: true
  belongs_to :market, inverse_of: :appraisals
  belongs_to :user, inverse_of: :appraisals, optional: true

  has_many :items, class_name: 'AppraisalItem', dependent: :destroy

  accepts_nested_attributes_for :items

  delegate :name, to: :market, prefix: true
  delegate :name, to: :user, prefix: true

  validates :code, presence: true, uniqueness: true
  validates :market_time, presence: true
  validates :price_period, presence: true, inclusion: { in: PRICE_PERIODS }
  validates :price_stat, presence: true, inclusion: { in: PRICE_STATS }
  validates :price_type, presence: true, inclusion: { in: PRICE_TYPES }

  before_validation :generate_code, on: :create
  before_validation :ensure_price_type, on: :create

  def generate_items(items, time = nil)
    self.market_time = time || market.latest_snapshot_time
    self.items_attributes = GenerateItems.call(items, market, market_time)
    self
  end

  AppraisalItem.column_names.grep(/price/).each do |stat|
    define_method :"total_#{stat}" do
      items.sum(&:"total_#{stat}") * (price_modifier || 1.0)
    end
  end

  def total_packaged_volume
    items.includes(:type).sum(&:total_packaged_volume)
  end

  def total_volume
    items.includes(:type).sum(&:total_volume)
  end

  private

  CODE_ALPHABET = '0123456789abcdefghjkmnopqrstvwxyzABCDEFGHJKMNPQRSTVWXYZ'

  def generate_code
    self.code = Nanoid.generate(size: 6, alphabet: CODE_ALPHABET) if code.blank?
  end

  def ensure_price_period
    self.price_period = DEFAULT_PRICE_PERIOD if price_period.blank?
  end

  def ensure_price_type
    self.price_type = DEFAULT_PRICE_TYPE if price_type.blank?
  end

  def ensure_price_stat
    self.price_stat = DEFAULT_PRICE_STAT if price_stat.blank?
  end
end
