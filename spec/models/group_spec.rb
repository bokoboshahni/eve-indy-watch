# frozen_string_literal: true

# ## Schema Information
#
# Table name: `groups`
#
# ### Columns
#
# Name                        | Type               | Attributes
# --------------------------- | ------------------ | ---------------------------
# **`id`**                    | `bigint`           | `not null, primary key`
# **`esi_expires_at`**        | `datetime`         |
# **`esi_last_modified_at`**  | `datetime`         |
# **`name`**                  | `text`             | `not null`
# **`published`**             | `boolean`          | `not null`
# **`created_at`**            | `datetime`         | `not null`
# **`updated_at`**            | `datetime`         | `not null`
# **`category_id`**           | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_groups_on_category_id`:
#     * **`category_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`category_id => categories.id`**
#
require 'rails_helper'

RSpec.describe Group, type: :model do
end
