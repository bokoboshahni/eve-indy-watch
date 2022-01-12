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
require 'rails_helper'

RSpec.describe Killmail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
