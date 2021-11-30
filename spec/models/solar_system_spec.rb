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
require 'rails_helper'

RSpec.describe SolarSystem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
