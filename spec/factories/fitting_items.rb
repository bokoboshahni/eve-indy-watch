# frozen_string_literal: true

# ## Schema Information
#
# Table name: `fitting_items`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `bigint`           | `not null, primary key`
# **`offline`**     | `boolean`          |
# **`quantity`**    | `integer`          | `not null`
# **`fitting_id`**  | `bigint`           | `not null`
# **`type_id`**     | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_fitting_items_on_fitting_id`:
#     * **`fitting_id`**
# * `index_fitting_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
FactoryBot.define do
  factory :fitting_item do
  end
end
