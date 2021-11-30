# frozen_string_literal: true

# ## Schema Information
#
# Table name: `fitting_items`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`flag`**        | `enum`             | `not null, primary key`
# **`online`**      | `boolean`          |
# **`quantity`**    | `integer`          | `not null`
# **`charge_id`**   | `bigint`           |
# **`fitting_id`**  | `bigint`           | `not null, primary key`
# **`type_id`**     | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_fitting_items_on_charge_id`:
#     * **`charge_id`**
# * `index_fitting_items_on_fitting_id`:
#     * **`fitting_id`**
# * `index_fitting_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`charge_id => types.id`**
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
require 'rails_helper'

RSpec.describe FittingItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
