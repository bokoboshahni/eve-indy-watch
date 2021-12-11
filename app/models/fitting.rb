# ## Schema Information
#
# Table name: `fittings`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `bigint`           | `not null, primary key`
# **`desired_count`**  | `integer`          |
# **`discarded_at`**   | `datetime`         |
# **`name`**           | `text`             | `not null`
# **`original`**       | `text`             |
# **`owner_type`**     | `string`           | `not null`
# **`pinned`**         | `boolean`          |
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`owner_id`**       | `bigint`           | `not null`
# **`type_id`**        | `bigint`           | `not null`
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

  has_paper_trail

  belongs_to :owner, polymorphic: true
  belongs_to :type, inverse_of: :fittings

  has_many :contract_fittings, -> { where('quantity > 0') }, inverse_of: :fitting, dependent: :destroy
  has_many :contracts, through: :contract_fittings
  has_many :items, class_name: 'FittingItem', inverse_of: :fitting, dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true

  scope :pinned, -> { where(pinned: true) }

  def compact_items
    items.select(:type_id, :quantity).each_with_object({}) do |item, h|
      type_id = item.type_id
      if h.key?(type_id)
        h[type_id] += item.quantity
      else
        h[type_id] = item.quantity
      end
    end
  end

  def contracts_on_hand
    contracts.outstanding
  end

  def contracts_received(period = nil)
    contracts.where(issued_at: build_period(period))
  end

  def contracts_sold(period = nil)
    contracts.finished.where(completed_at: build_period(period))
  end

  def contracts_sell_through_rate(period = nil)
    (contracts_sold(build_period(period)).count.to_d / contracts_received(build_period(period)).count.to_d) * 100.0
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
end
