# frozen_string_literal: true

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
FactoryBot.define do
  factory :blueprint_skill do
  end
end
