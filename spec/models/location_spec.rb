# ## Schema Information
#
# Table name: `locations`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`locatable_type`**  | `string`           | `not null`
# **`name`**            | `text`             | `not null`
# **`created_at`**      | `datetime`         | `not null`
# **`updated_at`**      | `datetime`         | `not null`
# **`locatable_id`**    | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_locations_on_locatable`:
#     * **`locatable_type`**
#     * **`locatable_id`**
# * `index_unique_locations` (_unique_):
#     * **`locatable_id`**
#     * **`locatable_type`**
#
require 'rails_helper'

RSpec.describe Location, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
