# frozen_string_literal: true

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
class BlueprintMaterial < ApplicationRecord
  self.primary_key = :blueprint_type_id, :material_type_id, :activity

  enum activity: %i[
    copying
    invention
    manufacturing
    research_material
    research_time
    reaction
  ].index_with(&:to_s)

  # belongs_to :blueprint_activity, inverse_of: :materials
  belongs_to :blueprint_type, class_name: 'Type', inverse_of: :blueprint_materials
  belongs_to :material_type, class_name: 'Type', inverse_of: :blueprint_required_materials
end
