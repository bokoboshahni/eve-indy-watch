# frozen_string_literal: true

# ## Schema Information
#
# Table name: `killmail_items`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint`           | `not null, primary key`
# **`ancestry`**            | `text`             |
# **`ancestry_depth`**      | `integer`          |
# **`quantity_destroyed`**  | `bigint`           |
# **`quantity_dropped`**    | `bigint`           |
# **`singleton`**           | `integer`          | `not null`
# **`flag_id`**             | `bigint`           |
# **`killmail_id`**         | `bigint`           | `not null`
# **`type_id`**             | `bigint`           |
#
# ### Indexes
#
# * `index_killmail_items_on_ancestry`:
#     * **`ancestry`**
# * `index_killmail_items_on_flag_id`:
#     * **`flag_id`**
# * `index_killmail_items_on_killmail_id`:
#     * **`killmail_id`**
# * `index_killmail_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`killmail_id => killmails.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
class KillmailItem < ApplicationRecord
  FITTING_FLAG_NAMES = %w[
    LoSlot0
    LoSlot1
    LoSlot2
    LoSlot3
    LoSlot4
    LoSlot5
    LoSlot6
    LoSlot7
    MedSlot0
    MedSlot1
    MedSlot2
    MedSlot3
    MedSlot4
    MedSlot5
    MedSlot6
    MedSlot7
    HiSlot0
    HiSlot1
    HiSlot2
    HiSlot3
    HiSlot4
    HiSlot5
    HiSlot6
    HiSlot7
    RigSlot0
    RigSlot1
    RigSlot2
    RigSlot3
    RigSlot4
    RigSlot5
    RigSlot6
    RigSlot7
    SubSystem0
    SubSystem1
    SubSystem2
    SubSystem3
    SubSystem4
    SubSystem5
    SubSystem6
    SubSystem7
  ].freeze

  has_ancestry cache_depth: true

  belongs_to :flag, class_name: 'InventoryFlag', inverse_of: :killmail_items, optional: true
  belongs_to :killmail, inverse_of: :items
  belongs_to :type, inverse_of: :killmail_items
end
