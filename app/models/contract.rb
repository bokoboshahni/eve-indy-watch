# frozen_string_literal: true

# ## Schema Information
#
# Table name: `contracts`
#
# ### Columns
#
# Name                              | Type               | Attributes
# --------------------------------- | ------------------ | ---------------------------
# **`id`**                          | `bigint`           | `not null, primary key`
# **`accepted_at`**                 | `datetime`         |
# **`acceptor_name`**               | `text`             |
# **`acceptor_type`**               | `string`           |
# **`assignee_name`**               | `text`             |
# **`assignee_type`**               | `string`           | `not null`
# **`availability`**                | `text`             | `not null`
# **`buyout`**                      | `decimal(, )`      |
# **`collateral`**                  | `decimal(, )`      |
# **`completed_at`**                | `datetime`         |
# **`days_to_complete`**            | `integer`          |
# **`end_location_name`**           | `text`             |
# **`end_location_type`**           | `string`           |
# **`esi_expires_at`**              | `datetime`         | `not null`
# **`esi_items_exception`**         | `jsonb`            |
# **`esi_items_expires_at`**        | `datetime`         |
# **`esi_items_last_modified_at`**  | `datetime`         |
# **`esi_last_modified_at`**        | `datetime`         | `not null`
# **`expired_at`**                  | `datetime`         | `not null`
# **`for_corporation`**             | `boolean`          |
# **`issued_at`**                   | `datetime`         | `not null`
# **`price`**                       | `decimal(, )`      |
# **`reward`**                      | `decimal(, )`      |
# **`start_location_name`**         | `text`             |
# **`start_location_type`**         | `string`           |
# **`status`**                      | `text`             | `not null`
# **`title`**                       | `text`             |
# **`type`**                        | `text`             | `not null`
# **`volume`**                      | `decimal(, )`      |
# **`created_at`**                  | `datetime`         | `not null`
# **`updated_at`**                  | `datetime`         | `not null`
# **`acceptor_id`**                 | `bigint`           |
# **`assignee_id`**                 | `bigint`           | `not null`
# **`end_location_id`**             | `bigint`           |
# **`issuer_corporation_id`**       | `bigint`           | `not null`
# **`issuer_id`**                   | `bigint`           | `not null`
# **`start_location_id`**           | `bigint`           |
#
# ### Indexes
#
# * `index_contracts_on_acceptor`:
#     * **`acceptor_type`**
#     * **`acceptor_id`**
# * `index_contracts_on_assignee`:
#     * **`assignee_type`**
#     * **`assignee_id`**
# * `index_contracts_on_end_location`:
#     * **`end_location_type`**
#     * **`end_location_id`**
# * `index_contracts_on_issuer_corporation_id`:
#     * **`issuer_corporation_id`**
# * `index_contracts_on_issuer_id`:
#     * **`issuer_id`**
# * `index_contracts_on_start_location`:
#     * **`start_location_type`**
#     * **`start_location_id`**
# * `index_contracts_on_status`:
#     * **`status`**
# * `index_contracts_on_title`:
#     * **`title`**
# * `index_contracts_on_type`:
#     * **`type`**
#
class Contract < ApplicationRecord
  include PgSearch::Model

  MULTISEARCH_FIELDS = %i[
    title acceptor_name assignee_name end_location_name issuer_name
    issuer_corporation_name start_location_name fitting_names item_names
  ]

  self.inheritance_column = nil

  multisearchable against: MULTISEARCH_FIELDS, if: -> r { r.outstanding? && r.item_exchange? }

  pg_search_scope :search_by_all, against: %i[title acceptor_name assignee_name end_location_name start_location_name],
                                  associated_against: {
                                    fittings: :name,
                                    issuer: :name,
                                    issuer_corporation: :name,
                                    types: :name
                                  },
                                  using: {
                                    tsearch: { prefix: true }
                                  }

  has_paper_trail ignore: %i[updated_at esi_expires_at esi_last_modified_at esi_items_exception esi_items_expires_at esi_items_last_modified_at],
                  versions: { class_name: 'ContractVersion' }

  belongs_to :acceptor, polymorphic: true, optional: true
  belongs_to :assignee, polymorphic: true
  belongs_to :end_location, polymorphic: true, optional: true
  belongs_to :issuer, class_name: 'Character', inverse_of: :issued_contracts
  belongs_to :issuer_corporation, class_name: 'Corporation', inverse_of: :issued_contracts
  belongs_to :start_location, polymorphic: true, optional: true

  has_many :contract_fittings, inverse_of: :contract, dependent: :destroy
  has_many :events, class_name: 'ContractEvent', inverse_of: :contract, dependent: :destroy
  has_many :fittings, through: :contract_fittings
  has_many :items, class_name: 'ContractItem', inverse_of: :contract, dependent: :destroy
  has_many :types, through: :items

  delegate :name, to: :issuer, prefix: true
  delegate :name, to: :issuer_corporation, prefix: true

  scope :courier, -> { where(type: 'courier') }
  scope :expired, -> { outstanding.where('expired_at <= ?', Time.zone.now) }
  scope :finished, -> { where(status: 'finished') }
  scope :in_progress, -> { where(status: 'in_progress') }
  scope :item_exchange, -> { where(type: 'item_exchange', esi_items_exception: nil) }
  scope :outstanding, -> { where(status: 'outstanding') }

  scope :items_inaccessible, -> { where(type: 'item_exchange').where("esi_items_exception->>'m' LIKE '(403)%'") }

  scope :at, -> id { where(end_location_id: id) }

  scope :assigned_to, -> id { where(assignee_id: id) }

  def courier?
    type == 'courier'
  end

  def item_exchange?
    type == 'item_exchange'
  end

  def deleted?
    status == 'deleted'
  end

  def finished?
    status == 'finished'
  end

  def done?
    deleted? || finished?
  end

  def outstanding?
    status == 'outstanding'
  end

  def fitting_names
    fittings.pluck(:name)
  end

  def item_names
    items.includes(:type).pluck('types.name')
  end

  def sync_items_from_esi!
    return unless esi_items_unsynced?

    Contract::SyncItemsFromESI.call(self)
  end

  def sync_items_from_esi_async
    return unless esi_items_unsynced?

    Contract::SyncItemsFromESIWorker.perform_async(id)
  end

  def esi_items_exception_class_name
    esi_items_exception&.fetch('json_class')
  end

  def esi_items_synced?
    esi_items_exception_class_name.nil? && esi_items_last_modified_at.present?
  end

  def esi_items_unsynced?
    esi_items_last_modified_at.blank? && !esi_items_inaccessible? && !esi_items_unavailable? && type != 'courier'
  end

  def esi_items_inaccessible?
    esi_items_exception_class_name == 'ESI::Errors::ForbiddenError'
  end

  def esi_items_rate_limited?
    esi_items_exception_class_name == 'ESI::Errors::ErrorLimitedError'
  end

  def esi_items_unavailable?
    esi_items_exception_class_name == 'ESI::Errors::NotFoundError'
  end

  def discover_fittings!
    Contract::DiscoverFittings.call(self)
  end

  def discover_fittings_async
    Contract::DiscoverFittingsWorker.perform_async(id)
  end

  def type_ids
    items.pluck(:type_id)
  end

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

  def description
    title.strip.present? ? title : '[No description]'
  end

  def icon_url
    if fittings.pluck(:type_id).uniq.count == 1
      fittings.first.type.icon_url
    else
      "https://images.evetech.net/types/3468/icon"
    end
  end

  def valuation(market)
    @valuation ||= Appraisal.new(market: market).generate_items(compact_items)
  end

  def valuation_sell(market)
    valuation(market).total_sell_price_min
  end

  def profit_sell(market)
    price - valuation_sell(market)
  end

  def margin_sell_pct(market)
    (profit_sell(market) / price) * 100.0
  end

  def markup_sell_pct(market)
    (profit_sell(market) / valuation_sell(market)) * 100.0
  end
end
