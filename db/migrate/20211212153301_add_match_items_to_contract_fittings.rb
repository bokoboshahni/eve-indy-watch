# frozen_string_literal: true

class AddMatchItemsToContractFittings < ActiveRecord::Migration[6.1]
  def change
    add_column :contract_fittings, :items, :jsonb
    add_column :contract_fittings, :similarity, :decimal
  end
end
