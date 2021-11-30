# frozen_string_literal: true

# ## Schema Information
#
# Table name: `fitting_items`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`flag`**        | `enum`             | `not null, primary key`
# **`online`**      | `boolean`          |
# **`quantity`**    | `integer`          | `not null`
# **`charge_id`**   | `bigint`           |
# **`fitting_id`**  | `bigint`           | `not null, primary key`
# **`type_id`**     | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_fitting_items_on_charge_id`:
#     * **`charge_id`**
# * `index_fitting_items_on_fitting_id`:
#     * **`fitting_id`**
# * `index_fitting_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`charge_id => types.id`**
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
class FittingItem < ApplicationRecord
  FLAG_TYPES = %i[
    cargo
    drone_bay
    fighter_bay
    hi_slot_0
    hi_slot_1
    hi_slot_2
    hi_slot_3
    hi_slot_4
    hi_slot_5
    hi_slot_6
    hi_slot_7
    invalid
    lo_slot_0
    lo_slot_1
    lo_slot_2
    lo_slot_3
    lo_slot_4
    lo_slot_5
    lo_slot_6
    lo_slot_7
    med_slot_0
    med_slot_1
    med_slot_2
    med_slot_3
    med_slot_4
    med_slot_5
    med_slot_6
    med_slot_7
    rig_slot_0
    rig_slot_1
    rig_slot_2
    service_slot_0
    service_slot_1
    service_slot_2
    service_slot_3
    service_slot_4
    service_slot_5
    service_slot_6
    service_slot_7
    subsystem_slot_0
    subsystem_slot_1
    subsystem_slot_2
    subsystem_slot_3
  ].freeze

  self.inheritance_column = nil
  self.primary_keys = :fitting_id, :flag, :type_id

  belongs_to :fitting, inverse_of: :items

  enum flag: FLAG_TYPES.each_with_object({}) { |f, h| h[f] = f.to_s }

  validates :flag, inclusion: { in: FLAG_TYPES }
end
