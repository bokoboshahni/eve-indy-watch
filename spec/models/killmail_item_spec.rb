# frozen_string_literal: true

# ## Schema Information
#
# Table name: `killmail_items`
#
# ### Columns
#
# Name                      | Type               | Attributes
# ------------------------- | ------------------ | ---------------------------
# **`id`**                  | `bigint`           | `not null, primary key`
# **`ancestry`**            | `text`             |
# **`ancestry_depth`**      | `integer`          |
# **`quantity_destroyed`**  | `bigint`           |
# **`quantity_dropped`**    | `bigint`           |
# **`singleton`**           | `integer`          | `not null`
# **`flag_id`**             | `bigint`           |
# **`killmail_id`**         | `bigint`           | `not null`
# **`type_id`**             | `bigint`           |
#
# ### Indexes
#
# * `index_killmail_items_on_ancestry`:
#     * **`ancestry`**
# * `index_killmail_items_on_flag_id`:
#     * **`flag_id`**
# * `index_killmail_items_on_killmail_id`:
#     * **`killmail_id`**
# * `index_killmail_items_on_type_id`:
#     * **`type_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`killmail_id => killmails.id`**
# * `fk_rails_...`:
#     * **`type_id => types.id`**
#
require 'rails_helper'

RSpec.describe KillmailItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
