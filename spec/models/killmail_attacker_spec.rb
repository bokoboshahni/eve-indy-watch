# ## Schema Information
#
# Table name: `killmail_attackers`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`damage_done`**      | `integer`          | `not null`
# **`final_blow`**       | `boolean`          | `not null`
# **`security_status`**  | `decimal(, )`      | `not null`
# **`alliance_id`**      | `bigint`           |
# **`character_id`**     | `bigint`           |
# **`corporation_id`**   | `bigint`           |
# **`faction_id`**       | `bigint`           |
# **`killmail_id`**      | `bigint`           | `not null`
# **`ship_type_id`**     | `bigint`           |
# **`weapon_type_id`**   | `bigint`           |
#
# ### Indexes
#
# * `index_killmail_attackers_on_alliance_id`:
#     * **`alliance_id`**
# * `index_killmail_attackers_on_character_id`:
#     * **`character_id`**
# * `index_killmail_attackers_on_corporation_id`:
#     * **`corporation_id`**
# * `index_killmail_attackers_on_killmail_id`:
#     * **`killmail_id`**
# * `index_killmail_attackers_on_ship_type_id`:
#     * **`ship_type_id`**
# * `index_killmail_attackers_on_weapon_type_id`:
#     * **`weapon_type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`killmail_id => killmails.id`**
# * `fk_rails_...`:
#     * **`ship_type_id => types.id`**
# * `fk_rails_...`:
#     * **`weapon_type_id => types.id`**
#
require 'rails_helper'

RSpec.describe KillmailAttacker, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
