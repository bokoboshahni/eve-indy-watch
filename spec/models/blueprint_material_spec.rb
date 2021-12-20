# ## Schema Information
#
# Table name: `blueprint_materials`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`activity`**           | `enum`             | `not null, primary key`
# **`quantity`**           | `integer`          | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`blueprint_type_id`**  | `bigint`           | `not null, primary key`
# **`material_type_id`**   | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_materials_on_blueprint_type_id`:
#     * **`blueprint_type_id`**
# * `index_blueprint_materials_on_material_type_id`:
#     * **`material_type_id`**
# * `index_unique_blueprint_materials` (_unique_):
#     * **`blueprint_type_id`**
#     * **`material_type_id`**
#     * **`activity`**
#
require 'rails_helper'

RSpec.describe BlueprintMaterial, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
