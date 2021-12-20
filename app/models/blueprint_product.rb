# ## Schema Information
#
# Table name: `blueprint_products`
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
# **`product_type_id`**    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_blueprint_products_on_blueprint_type_id`:
#     * **`blueprint_type_id`**
# * `index_blueprint_products_on_product_type_id`:
#     * **`product_type_id`**
# * `index_unique_blueprint_products` (_unique_):
#     * **`blueprint_type_id`**
#     * **`product_type_id`**
#     * **`activity`**
#
class BlueprintProduct < ApplicationRecord
  self.primary_key = :blueprint_type_id, :product_type_id, :activity

  enum activity: %i[
    copying
    invention
    manufacturing
    research_material
    research_time
    reaction
  ].each_with_object({}) { |v, h| h[v] = v.to_s }

  belongs_to :blueprint_activity, inverse_of: :materials
  belongs_to :blueprint_type, class_name: 'Type', inverse_of: :blueprint_products
  belongs_to :product_type, class_name: 'Type', inverse_of: :blueprint_output_products
end
