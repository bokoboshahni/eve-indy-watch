# frozen_string_literal: true

# ## Schema Information
#
# Table name: `contracts`
#
# ### Columns
#
# Name                              | Type               | Attributes
# --------------------------------- | ------------------ | ---------------------------
# **`id`**                          | `bigint`           | `not null, primary key`
# **`accepted_at`**                 | `datetime`         |
# **`acceptor_type`**               | `string`           |
# **`assignee_type`**               | `string`           | `not null`
# **`availability`**                | `text`             | `not null`
# **`buyout`**                      | `decimal(, )`      |
# **`collateral`**                  | `decimal(, )`      |
# **`completed_at`**                | `datetime`         |
# **`days_to_complete`**            | `integer`          |
# **`end_location_type`**           | `string`           |
# **`esi_expires_at`**              | `datetime`         | `not null`
# **`esi_items_exception`**         | `jsonb`            |
# **`esi_items_expires_at`**        | `datetime`         |
# **`esi_items_last_modified_at`**  | `datetime`         |
# **`esi_last_modified_at`**        | `datetime`         | `not null`
# **`expired_at`**                  | `datetime`         | `not null`
# **`for_corporation`**             | `boolean`          |
# **`issued_at`**                   | `datetime`         | `not null`
# **`price`**                       | `decimal(, )`      |
# **`reward`**                      | `decimal(, )`      |
# **`start_location_type`**         | `string`           |
# **`status`**                      | `text`             | `not null`
# **`title`**                       | `text`             |
# **`type`**                        | `text`             | `not null`
# **`volume`**                      | `decimal(, )`      |
# **`created_at`**                  | `datetime`         | `not null`
# **`updated_at`**                  | `datetime`         | `not null`
# **`acceptor_id`**                 | `bigint`           |
# **`assignee_id`**                 | `bigint`           | `not null`
# **`end_location_id`**             | `bigint`           |
# **`issuer_corporation_id`**       | `bigint`           | `not null`
# **`issuer_id`**                   | `bigint`           | `not null`
# **`start_location_id`**           | `bigint`           |
#
# ### Indexes
#
# * `index_contracts_on_acceptor`:
#     * **`acceptor_type`**
#     * **`acceptor_id`**
# * `index_contracts_on_assignee`:
#     * **`assignee_type`**
#     * **`assignee_id`**
# * `index_contracts_on_end_location`:
#     * **`end_location_type`**
#     * **`end_location_id`**
# * `index_contracts_on_issuer_corporation_id`:
#     * **`issuer_corporation_id`**
# * `index_contracts_on_issuer_id`:
#     * **`issuer_id`**
# * `index_contracts_on_start_location`:
#     * **`start_location_type`**
#     * **`start_location_id`**
# * `index_contracts_on_status`:
#     * **`status`**
# * `index_contracts_on_title`:
#     * **`title`**
# * `index_contracts_on_type`:
#     * **`type`**
#
require 'rails_helper'

RSpec.describe Contract, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
