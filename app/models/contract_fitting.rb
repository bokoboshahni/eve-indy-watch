# frozen_string_literal: true

# ## Schema Information
#
# Table name: `contract_fittings`
#
# ### Columns
#
# Name               | Type               | Attributes
# ------------------ | ------------------ | ---------------------------
# **`items`**        | `jsonb`            |
# **`quantity`**     | `integer`          | `not null`
# **`similarity`**   | `decimal(, )`      |
# **`created_at`**   | `datetime`         | `not null`
# **`updated_at`**   | `datetime`         | `not null`
# **`contract_id`**  | `bigint`           | `not null, primary key`
# **`fitting_id`**   | `bigint`           | `not null, primary key`
#
# ### Indexes
#
# * `index_contract_fittings_on_fitting_id`:
#     * **`fitting_id`**
# * `index_unique_contract_fittings` (_unique_):
#     * **`contract_id`**
#     * **`fitting_id`**
#
# ### Foreign Keys
#
# * `fk_rails_...`:
#     * **`contract_id => contracts.id`**
# * `fk_rails_...`:
#     * **`fitting_id => fittings.id`**
#
class ContractFitting < ApplicationRecord
  self.primary_keys = :contract_id, :fitting_id

  belongs_to :contract, inverse_of: :contract_fittings
  belongs_to :fitting, inverse_of: :contract_fittings

  delegate :items, to: :fitting, prefix: true

  scope :fully_matching, -> { where('quantity > 0') }

  scope :matching, -> { joins(:fitting).where('similarity >= COALESCE(fittings.contract_match_threshold, 1.0)') }

  scope :outstanding, -> { joins(:contract).where("contracts.status = 'outstanding'") }

  def types
    Type.find(items.keys).each_with_object({}) { |t, h| h[t.id] = t }
  end

  def items_comparison
    @items_comparison ||=
      begin
        contract_items = contract.compact_items
        fitting_items = fitting.compact_items

        items = fitting_items.transform_keys(&:to_i).each_with_object([]) do |(type_id, contract_qty), a|
          a << {
            type: types[type_id],
            contract_quantity: contract_items[type_id],
            fitting_quantity: fitting_items[type_id]
          }
        end
        items.sort_by { |i| i[:type].name }
      end
  end

  def extra_item_ids
    contract.type_ids - fitting.type_ids
  end

  def extra_items
    contract.items.includes(:type).where(type_id: extra_item_ids).order('types.name ASC')
  end
end
