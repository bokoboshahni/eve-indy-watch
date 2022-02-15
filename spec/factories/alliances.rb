# frozen_string_literal: true

# ## Schema Information
#
# Table name: `alliances`
#
# ### Columns
#
# Name                                    | Type               | Attributes
# --------------------------------------- | ------------------ | ---------------------------
# **`id`**                                | `bigint`           | `not null, primary key`
# **`esi_expires_at`**                    | `datetime`         | `not null`
# **`esi_last_modified_at`**              | `datetime`         | `not null`
# **`icon_url_128`**                      | `text`             |
# **`icon_url_64`**                       | `text`             |
# **`name`**                              | `text`             | `not null`
# **`procurement_order_requester_type`**  | `string`           |
# **`ticker`**                            | `text`             | `not null`
# **`zkb_fetched_at`**                    | `datetime`         |
# **`zkb_sync_enabled`**                  | `boolean`          |
# **`created_at`**                        | `datetime`         | `not null`
# **`updated_at`**                        | `datetime`         | `not null`
# **`api_corporation_id`**                | `bigint`           |
# **`appraisal_market_id`**               | `bigint`           |
# **`main_market_id`**                    | `bigint`           |
# **`procurement_order_requester_id`**    | `bigint`           |
#
# ### Indexes
#
# * `index_alliances_on_appraisal_market_id`:
#     * **`appraisal_market_id`**
# * `index_alliances_on_main_market_id`:
#     * **`main_market_id`**
# * `index_alliances_on_procurement_order_assignee`:
#     * **`procurement_order_requester_type`**
#     * **`procurement_order_requester_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`appraisal_market_id => markets.id`**
# * `fk_rails_...`:
#     * **`main_market_id => markets.id`**
#
FactoryBot.define do
  factory :alliance do
    id { Faker::Number.within(range: 99_000_000..100_000_000) }
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    name { Faker::Company.name }
    ticker { Faker::Finance.ticker }
  end
end
