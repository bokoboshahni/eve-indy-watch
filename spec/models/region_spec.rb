# frozen_string_literal: true

# ## Schema Information
#
# Table name: `regions`
#
# ### Columns
#
# Name                                      | Type               | Attributes
# ----------------------------------------- | ------------------ | ---------------------------
# **`id`**                                  | `bigint`           | `not null, primary key`
# **`esi_market_orders_expires_at`**        | `datetime`         |
# **`esi_market_orders_last_modified_at`**  | `datetime`         |
# **`market_order_sync_enabled`**           | `boolean`          |
# **`name`**                                | `text`             | `not null`
# **`orders_updated_at`**                   | `datetime`         |
# **`type_history_preload_enabled`**        | `boolean`          |
# **`created_at`**                          | `datetime`         | `not null`
# **`updated_at`**                          | `datetime`         | `not null`
# **`esi_authorization_id`**                | `bigint`           |
#
# ### Indexes
#
# * `index_regions_on_esi_authorization_id`:
#     * **`esi_authorization_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`esi_authorization_id => esi_authorizations.id`**
#
require 'rails_helper'

RSpec.describe Region, type: :model do
end
