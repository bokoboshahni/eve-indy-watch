# frozen_string_literal: true

# ## Schema Information
#
# Table name: `solar_systems`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `bigint`           | `not null, primary key`
# **`name`**              | `text`             | `not null`
# **`security`**          | `decimal(, )`      | `not null`
# **`created_at`**        | `datetime`         | `not null`
# **`updated_at`**        | `datetime`         | `not null`
# **`constellation_id`**  | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_solar_systems_on_constellation_id`:
#     * **`constellation_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`constellation_id => constellations.id`**
#
FactoryBot.define do
  factory :solar_system do
    association :constellation

    id { Faker::Number.within(range: 30_000_000..31_000_000) }
    name { Faker::Space.star }
    security { Faker::Number.within(range: 0.0..1.0) }
  end
end
