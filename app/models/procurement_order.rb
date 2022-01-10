# frozen_string_literal: true

# ## Schema Information
#
# Table name: `procurement_orders`
#
# ### Columns
#
# Name                             | Type               | Attributes
# -------------------------------- | ------------------ | ---------------------------
# **`id`**                         | `bigint`           | `not null, primary key`
# **`accepted_at`**                | `datetime`         |
# **`appraisal_url`**              | `text`             |
# **`bonus`**                      | `decimal(, )`      |
# **`deliver_by`**                 | `datetime`         |
# **`delivered_at`**               | `datetime`         |
# **`discarded_at`**               | `datetime`         |
# **`multiplier`**                 | `decimal(, )`      | `not null`
# **`notes`**                      | `text`             |
# **`published_at`**               | `datetime`         |
# **`requester_name`**             | `text`             |
# **`requester_type`**             | `string`           | `not null`
# **`split_fulfillment_enabled`**  | `boolean`          |
# **`status`**                     | `enum`             | `not null`
# **`supplier_name`**              | `text`             |
# **`supplier_type`**              | `string`           |
# **`tracking_number`**            | `bigint`           |
# **`created_at`**                 | `datetime`         | `not null`
# **`updated_at`**                 | `datetime`         | `not null`
# **`location_id`**                | `bigint`           | `not null`
# **`requester_id`**               | `bigint`           | `not null`
# **`supplier_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_procurement_orders_on_discarded_at`:
#     * **`discarded_at`**
# * `index_procurement_orders_on_location_id`:
#     * **`location_id`**
# * `index_procurement_orders_on_requester`:
#     * **`requester_type`**
#     * **`requester_id`**
# * `index_procurement_orders_on_supplier`:
#     * **`supplier_type`**
#     * **`supplier_id`**
#
class ProcurementOrder < ApplicationRecord
  include Discard::Model
  include PgSearch::Model

  STATUSES = %i[draft available in_progress delivered].freeze

  has_paper_trail

  multisearchable against: %i[requester_name supplier_name location_name item_names notes], if: ->(r) { r.kept? }

  pg_search_scope :search_by_all, against: %i[requester_name supplier_name notes],
                                  associated_against: {
                                    location: :name
                                  },
                                  using: {
                                    tsearch: { prefix: true }
                                  }

  enum status: STATUSES.index_with(&:to_s)

  attribute :multiplier, :decimal, default: 100.0

  belongs_to :requester, polymorphic: true, inverse_of: :requested_procurement_orders
  belongs_to :supplier, polymorphic: true, optional: true, inverse_of: :supplied_procurement_orders
  belongs_to :location, inverse_of: :procurement_orders

  has_many :items, class_name: 'ProcurementOrderItem', inverse_of: :order, foreign_key: :order_id, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: ->(a) { a[:type_id].blank? || a[:quantity_required].blank? || a[:price].blank? }

  validates :bonus, allow_blank: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than_or_equal_to: 0 }
  validates :multiplier, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates_associated :items

  validate :validate_already_accepted, on: :update
  validate :validate_redraft, on: :update
  validate :validate_has_items

  delegate :name, to: :location, prefix: true

  before_validation :ensure_requester_and_supplier_names

  def accept!(supplier)
    self.tracking_number = Nanoid.generate(size: 15, alphabet: '1234567890').to_i
    update(supplier: supplier, status: :in_progress, accepted_at: Time.zone.now)
  end

  def release!
    update(supplier: nil, status: :available, accepted_at: nil)
  end

  def receive!
    update(status: :delivered, delivered_at: Time.zone.now)
  end

  def redraft!
    update(status: :draft, published_at: nil)
  end

  def prefix
    case requester_type
    when 'Alliance'
      'A'
    when 'Corporation'
      'C'
    when 'Character'
      'U'
    end
  end

  def number
    "#{prefix}#{'%06d' % id}"
  end

  def requester_gid
    requester&.to_global_id
  end

  def requester_gid=(gid)
    self.requester = GlobalID::Locator.locate(gid)
  end

  def supplier_gid
    supplier&.to_global_id
  end

  def supplier_gid=(gid)
    self.supplier = GlobalID::Locator.locate(gid)
  end

  def subtotal
    items.pluck(:price, :quantity_required).sum { |i| i[0].to_d * i[1].to_d }
  end

  def subtotal_with_multiplier
    subtotal * (multiplier / 100.0)
  end

  def item_names
    items.joins(:type).pluck(:'types.name').uniq
  end

  def total
    subtotal_with_multiplier + bonus
  end

  def volume
    items.joins(:type).pluck(:quantity_required, :'types.packaged_volume', :'types.volume').sum { |i| i[0] * (i[1] || i[2]) }
  end

  private

  def ensure_requester_and_supplier_names
    self.requester_name = requester.name
    self.supplier_name = supplier&.name
  end

  def validate_redraft
    return unless status_changed?

    errors.add(:base, "Procurement order #{number} has a status of #{status_was.humanize.downcase} and cannot be edited.") if status == :draft && status_was != :available
  end

  def validate_already_accepted
    return unless status == :accepted && supplier_changed?

    errors.add(:base, "Procurement order #{number} has already been accepted.")
  end

  def validate_has_items
    return unless available? && items.empty?

    self.status = :draft
    errors.add(:base, 'Cannot publish procurement order with no items.')
  end
end
