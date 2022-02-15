# frozen_string_literal: true

# ## Schema Information
#
# Table name: `stations`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         |
# **`esi_last_modified_at`**  | `datetime`         |
# **`name`**                  | `text`             | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`owner_id`**              | `bigint`           | `not null`
# **`solar_system_id`**       | `bigint`           | `not null`
# **`type_id`**               | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_stations_on_owner_id`:
#     * **`owner_id`**
# * `index_stations_on_solar_system_id`:
#     * **`solar_system_id`**
# * `index_stations_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`owner_id => corporations.id`**
# * `fk_rails_...`:
#     * **`solar_system_id => solar_systems.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
FactoryBot.define do
  factory :station do
    association :owner, factory: :corporation
    association :solar_system
    association :type

    id { Faker::Number.within(range: 60_000_000..64_000_000) }
    name { "#{solar_system.name} I - Moon 1 - #{Faker::Space.agency}" }
  end
end
