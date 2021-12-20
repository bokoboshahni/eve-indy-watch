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
class BlueprintActivity < ApplicationRecord
  self.primary_keys = :blueprint_type_id, :activity

  enum activity: %i[
    copying
    invention
    manufacturing
    research_material
    research_time
    reaction
  ].each_with_object({}) { |v, h| h[v] = v.to_s }

  belongs_to :blueprint_type, inverse_of: :blueprint_activities

  has_many :materials, class_name: 'BlueprintMaterial', inverse_of: :blueprint_activity, foreign_key: %i[blueprint_type_id activity]
  has_many :products, class_name: 'BlueprintProduct', inverse_of: :blueprint_activity, foreign_key: %i[blueprint_type_id activity]
  has_many :skills, class_name: 'BlueprintSkill', inverse_of: :blueprint_activity, foreign_key: %i[blueprint_type_id activity]

  accepts_nested_attributes_for :materials
  accepts_nested_attributes_for :products
  accepts_nested_attributes_for :skills
end
