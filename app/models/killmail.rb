# frozen_string_literal: true

# ## Schema Information
#
# Table name: `killmails`
#
# ### Columns
#
# Name                       | Type               | Attributes
# -------------------------- | ------------------ | ---------------------------
# **`id`**                   | `bigint`           | `not null, primary key`
# **`awox`**                 | `boolean`          | `not null`
# **`damage_taken`**         | `integer`          | `not null`
# **`killmail_hash`**        | `text`             | `not null`
# **`npc`**                  | `boolean`          | `not null`
# **`points`**               | `integer`          | `not null`
# **`position_x`**           | `decimal(, )`      | `not null`
# **`position_y`**           | `decimal(, )`      | `not null`
# **`position_z`**           | `decimal(, )`      | `not null`
# **`solo`**                 | `boolean`          | `not null`
# **`time`**                 | `datetime`         | `not null`
# **`zkb_destroyed_value`**  | `decimal(, )`      | `not null`
# **`zkb_dropped_value`**    | `decimal(, )`      | `not null`
# **`zkb_total_value`**      | `decimal(, )`      | `not null`
# **`created_at`**           | `datetime`         | `not null`
# **`alliance_id`**          | `bigint`           |
# **`character_id`**         | `bigint`           |
# **`corporation_id`**       | `bigint`           |
# **`faction_id`**           | `bigint`           |
# **`moon_id`**              | `bigint`           |
# **`ship_type_id`**         | `bigint`           | `not null`
# **`solar_system_id`**      | `bigint`           |
# **`war_id`**               | `bigint`           |
#
# ### Indexes
#
# * `index_killmails_on_alliance_id`:
#     * **`alliance_id`**
# * `index_killmails_on_character_id`:
#     * **`character_id`**
# * `index_killmails_on_corporation_id`:
#     * **`corporation_id`**
# * `index_killmails_on_ship_type_id`:
#     * **`ship_type_id`**
# * `index_killmails_on_solar_system_id`:
#     * **`solar_system_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`ship_type_id => types.id`**
# * `fk_rails_...`:
#     * **`solar_system_id => solar_systems.id`**
#
class Killmail < ApplicationRecord
  belongs_to :alliance, optional: true, inverse_of: :lossmails
  belongs_to :character, optional: true, inverse_of: :lossmails
  belongs_to :corporation, optional: true, inverse_of: :lossmails
  belongs_to :ship_type, class_name: 'Type', inverse_of: :lossmails
  belongs_to :solar_system, inverse_of: :killails, optional: true

  has_many :attackers, class_name: 'KillmailAttacker', inverse_of: :killmail, dependent: :destroy
  has_many :fittings, through: :killmail_fittings
  has_many :items, class_name: 'KillmailItem', inverse_of: :killmail, dependent: :destroy
  has_many :killmail_fittings, inverse_of: :killmail, dependent: :destroy

  accepts_nested_attributes_for :attackers

  def self.import_from_esi!(zkb_data)
    Killmail::ImportFromESI.call(zkb_data)
  end

  def discover_fittings!
    Killmail::DiscoverFittings.call(self)
  end

  def discover_fittings_async
    Killmail::DiscoverFittingsWorker.perform_async(id)
  end

  def compact_items(scope = nil)
    (scope || items).each_with_object({}) do |item, h|
      type_id = item.type_id
      quantity = [item.quantity_destroyed, item.quantity_dropped].compact.sum
      h.key?(type_id) ? h[type_id] += quantity : h[type_id] = quantity
    end
  end

  def fitting_items
    scope = items.joins(:flag, type: { group: :category })
                 .where(categories: { name: Category::MODULE_CATEGORY_NAMES })
                 .where(inventory_flags: { name: KillmailItem::FITTING_FLAG_NAMES })
                 .select(:type_id, :quantity_destroyed, :quantity_dropped)
    compact_items(scope)
  end
end
