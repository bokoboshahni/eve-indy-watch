# frozen_string_literal: true

# ## Schema Information
#
# Table name: `contract_versions`
#
# ### Columns
#
# Name                  | Type               | Attributes
# --------------------- | ------------------ | ---------------------------
# **`id`**              | `bigint`           | `not null, primary key`
# **`event`**           | `text`             | `not null`
# **`item_type`**       | `string`           | `not null`
# **`object`**          | `jsonb`            |
# **`object_changes`**  | `jsonb`            |
# **`whodunnit`**       | `text`             |
# **`created_at`**      | `datetime`         | `not null`
# **`item_id`**         | `bigint`           | `not null`
#
# ### Indexes
#
# * `index_contract_versions_on_item`:
#     * **`item_type`**
#     * **`item_id`**
#
class ContractVersion < PaperTrail::Version
  self.table_name = :contract_versions
  self.sequence_name = :contract_versions_id_seq
end
