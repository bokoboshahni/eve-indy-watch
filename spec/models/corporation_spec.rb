# frozen_string_literal: true

# ## Schema Information
#
# Table name: `corporations`
#
# ### Columns
#
# Name                                    | Type               | Attributes
# --------------------------------------- | ------------------ | ---------------------------
# **`id`**                                | `bigint`           | `not null, primary key`
# **`contract_sync_enabled`**             | `boolean`          |
# **`esi_contracts_expires_at`**          | `datetime`         |
# **`esi_contracts_last_modified_at`**    | `datetime`         |
# **`esi_expires_at`**                    | `datetime`         |
# **`esi_last_modified_at`**              | `datetime`         |
# **`icon_url_128`**                      | `text`             |
# **`icon_url_256`**                      | `text`             |
# **`icon_url_64`**                       | `text`             |
# **`name`**                              | `text`             | `not null`
# **`npc`**                               | `boolean`          |
# **`procurement_order_requester_type`**  | `string`           |
# **`ticker`**                            | `text`             | `not null`
# **`url`**                               | `text`             |
# **`created_at`**                        | `datetime`         | `not null`
# **`updated_at`**                        | `datetime`         | `not null`
# **`alliance_id`**                       | `bigint`           |
# **`esi_authorization_id`**              | `integer`          |
# **`procurement_order_requester_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_corporations_on_alliance_id`:
#     * **`alliance_id`**
# * `index_corporations_on_esi_authorization_id`:
#     * **`esi_authorization_id`**
# * `index_corporations_on_procurement_order_requester`:
#     * **`procurement_order_requester_type`**
#     * **`procurement_order_requester_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`alliance_id => alliances.id`**
# * `fk_rails_...`:
#     * **`esi_authorization_id => esi_authorizations.id`**
#
require 'rails_helper'

RSpec.describe Corporation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
