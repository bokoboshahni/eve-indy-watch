# ## Schema Information
#
# Table name: `fittings`
#
# ### Columns
#
# Name                 | Type               | Attributes
# -------------------- | ------------------ | ---------------------------
# **`id`**             | `bigint`           | `not null, primary key`
# **`desired_count`**  | `integer`          |
# **`discarded_at`**   | `datetime`         |
# **`name`**           | `text`             | `not null`
# **`original`**       | `text`             |
# **`owner_type`**     | `string`           | `not null`
# **`pinned`**         | `boolean`          |
# **`created_at`**     | `datetime`         | `not null`
# **`updated_at`**     | `datetime`         | `not null`
# **`owner_id`**       | `bigint`           | `not null`
# **`type_id`**        | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_fittings_on_discarded_at`:
#     * **`discarded_at`**
# * `index_fittings_on_owner`:
#     * **`owner_type`**
#     * **`owner_id`**
# * `index_fittings_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
require 'rails_helper'

RSpec.describe Fitting, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
