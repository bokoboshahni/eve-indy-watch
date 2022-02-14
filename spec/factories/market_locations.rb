# frozen_string_literal: true

# ## Schema Information
#
# Table name: `market_locations`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`location_type`**  | `string`           | `not null, primary key`
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`location_id`**    | `bigint`           | `not null, primary key`
# **`market_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_market_locations_on_location`:
#     * **`location_type`**
#     * **`location_id`**
# * `index_market_locations_on_market_id`:
#     * **`market_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`market_id => markets.id`**
#
FactoryBot.define do
  factory :market_location do
  end
end
