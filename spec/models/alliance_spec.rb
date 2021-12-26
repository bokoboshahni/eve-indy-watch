# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         | `not null`
# **`esi_last_modified_at`**  | `datetime`         | `not null`
# **`icon_url_128`**          | `text`             |
# **`icon_url_64`**           | `text`             |
# **`name`**                  | `text`             | `not null`
# **`ticker`**                | `text`             | `not null`
# **`zkb_fetched_at`**        | `datetime`         |
# **`zkb_sync_enabled`**      | `boolean`          |
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`api_corporation_id`**    | `bigint`           |
# **`appraisal_market_id`**   | `bigint`           |
# **`main_market_id`**        | `bigint`           |
#
# ### Indexes
#
# * `index_alliances_on_appraisal_market_id`:
#     * **`appraisal_market_id`**
# * `index_alliances_on_main_market_id`:
#     * **`main_market_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`appraisal_market_id => markets.id`**
# * `fk_rails_...`:
#     * **`main_market_id => markets.id`**
#
require 'rails_helper'

RSpec.describe Alliance, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
