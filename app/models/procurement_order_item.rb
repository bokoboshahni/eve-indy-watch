# frozen_string_literal: true

# ## Schema Information
#
# Table name: `procurement_order_items`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`id`**                 | `bigint`           | `not null, primary key`
# **`accepted_at`**        | `datetime`         |
# **`bonus`**              | `decimal(, )`      |
# **`delivered_at`**       | `datetime`         |
# **`multiplier`**         | `decimal(, )`      | `not null`
# **`price`**              | `decimal(, )`      | `not null`
# **`quantity_received`**  | `bigint`           |
# **`quantity_required`**  | `bigint`           | `not null`
# **`status`**             | `enum`             | `default("available"), not null`
# **`supplier_name`**      | `text`             |
# **`supplier_type`**      | `string`           |
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`order_id`**           | `bigint`           | `not null`
# **`supplier_id`**        | `bigint`           |
# **`type_id`**            | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_procurement_order_items_on_order_id`:
#     * **`order_id`**
# * `index_procurement_order_items_on_supplier`:
#     * **`supplier_type`**
#     * **`supplier_id`**
# * `index_procurement_order_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`order_id => procurement_orders.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
class ProcurementOrderItem < ApplicationRecord
  self.inheritance_column = nil

  STATUSES = %i[draft available in_progress delivered].freeze

  has_paper_trail

  enum status: STATUSES.index_with(&:to_s)

  attribute :bonus, :decimal, default: 0
  attribute :multiplier, :decimal, default: 100.0

  belongs_to :order, class_name: 'ProcurementOrder', inverse_of: :items
  belongs_to :supplier, polymorphic: true, optional: true, inverse_of: :supplied_procurement_order_items
  belongs_to :type, inverse_of: :procurement_order_items

  validates :bonus, allow_blank: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :multiplier, allow_blank: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0 }
  validates :price, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0 }
  validates :quantity_received, allow_blank: true, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity_required, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys }

  validate :validate_already_accepted, on: :update

  delegate :category, :group, :name, to: :type
  delegate :name, to: :category, prefix: true
  delegate :name, to: :group, prefix: true

  before_validation :ensure_supplier_name

  def price_with_multiplier
    price * ((order.multiplier || 100.0) / 100.0)
  end

  def supplier_gid
    supplier&.to_global_id
  end

  def supplier_gid=(gid)
    self.supplier = GlobalID::Locator.locate(gid)
  end

  def subtotal
    quantity_required * price
  end

  def subtotal_with_multiplier
    subtotal * ((order.multiplier || 100.0) / 100.0)
  end

  def total
    subtotal_with_multiplier + bonus
  end

  def volume
    quantity_required * (type.packaged_volume || type.volume)
  end

  private

  def ensure_supplier_name
    self.supplier_name = supplier&.name
  end

  def validate_already_accepted
    return unless status == :accepted && supplier_changed?

    errors.add(:base, :already_accepted, "Procurement order #{order.number} has already been accepted.")
  end
end
