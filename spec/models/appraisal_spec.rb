# frozen_string_literal: true

# ## Schema Information
#
# Table name: `appraisals`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`appraisable_type`**  | `string`           |
# **`code`**              | `text`             | `not null`
# **`description`**       | `text`             |
# **`expires_at`**        | `datetime`         |
# **`market_time`**       | `datetime`         | `not null`
# **`original`**          | `text`             |
# **`price_modifier`**    | `decimal(, )`      |
# **`price_period`**      | `text`             | `not null`
# **`price_stat`**        | `text`             | `not null`
# **`price_type`**        | `text`             | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`appraisable_id`**    | `bigint`           |
# **`market_id`**         | `bigint`           | `not null`
# **`user_id`**           | `bigint`           |
#
# ### Indexes
#
# * `index_appraisals_on_appraisable`:
#     * **`appraisable_type`**
#     * **`appraisable_id`**
# * `index_appraisals_on_code` (_unique_):
#     * **`code`**
# * `index_appraisals_on_market_id`:
#     * **`market_id`**
# * `index_appraisals_on_user_id`:
#     * **`user_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
# * `fk_rails_...`:
#     * **`user_id => users.id`**
#
require 'rails_helper'

RSpec.describe Appraisal, type: :model do
end
