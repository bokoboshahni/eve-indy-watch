# frozen_string_literal: true

# ## Schema Information
#
# Table name: `stations`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `bigint`           | `not null, primary key`
# **`name`**             | `text`             | `not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
# **`owner_id`**         | `bigint`           | `not null`
# **`solar_system_id`**  | `bigint`           | `not null`
# **`type_id`**          | `bigint`           | `not null`
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
require 'rails_helper'

RSpec.describe Station, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
