# frozen_string_literal: true

# ## Schema Information
#
# Table name: `constellations`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`name`**        | `text`             | `not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
# **`region_id`**   | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_constellations_on_region_id`:
#     * **`region_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`region_id => regions.id`**
#
require 'rails_helper'

RSpec.describe Constellation, type: :model do
end
