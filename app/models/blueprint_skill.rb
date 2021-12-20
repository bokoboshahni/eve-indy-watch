# ## Schema Information
#
# Table name: `blueprint_skills`
#
# ### Columns
#
# Name                     | Type               | Attributes
# ------------------------ | ------------------ | ---------------------------
# **`activity`**           | `enum`             | `not null, primary key`
# **`level`**              | `integer`          | `not null`
# **`created_at`**         | `datetime`         | `not null`
# **`updated_at`**         | `datetime`         | `not null`
# **`blueprint_type_id`**  | `bigint`           | `not null, primary key`
# **`skill_type_id`**      | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_skills_on_blueprint_type_id`:
#     * **`blueprint_type_id`**
# * `index_blueprint_skills_on_skill_type_id`:
#     * **`skill_type_id`**
# * `index_unique_blueprint_skills` (_unique_):
#     * **`blueprint_type_id`**
#     * **`skill_type_id`**
#     * **`activity`**
#
class BlueprintSkill < ApplicationRecord
  self.primary_key = :blueprint_type_id, :skill_type_id, :activity

  enum activity: %i[
    copying
    invention
    manufacturing
    research_material
    research_time
    reaction
  ].each_with_object({}) { |v, h| h[v] = v.to_s }

  belongs_to :blueprint_activity, inverse_of: :materials
  belongs_to :blueprint_type, class_name: 'Type', inverse_of: :blueprint_skills
  belongs_to :skill_type, class_name: 'Type', inverse_of: :blueprint_required_skills
end
