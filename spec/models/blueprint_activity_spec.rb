# ## Schema Information
#
# Table name: `blueprint_activities`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`activity`**           | `enum`             | `not null, primary key`
# **`time`**               | `integer`          | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`blueprint_type_id`**  | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_activities_on_blueprint_type_id`:
#     * **`blueprint_type_id`**
# * `index_unique_blueprint_activities` (_unique_):
#     * **`blueprint_type_id`**
#     * **`activity`**
#
require 'rails_helper'

RSpec.describe BlueprintActivity, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
