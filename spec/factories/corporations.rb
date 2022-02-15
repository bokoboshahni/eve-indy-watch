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
FactoryBot.define do
  factory :corporation do
    id { Faker::Number.within(range: 98_000_000..99_000_000) }
    esi_expires_at { 1.hour.from_now }
    esi_last_modified_at { Time.zone.now }
    name { Faker::Company.name }
    ticker { Faker::Finance.ticker }

    trait :with_alliance do
      alliance
    end
  end
end
