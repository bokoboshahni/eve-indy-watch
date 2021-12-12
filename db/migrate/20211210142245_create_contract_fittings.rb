# frozen_string_literal: true

class CreateContractFittings < ActiveRecord::Migration[6.1]
  def change
    create_table :contract_fittings, id: false, primary_key: %i[contract_id fitting_id] do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :fitting, null: false, foreign_key: true

      t.integer :quantity, null: false
      t.timestamps null: false

      t.index %i[contract_id fitting_id], unique: true, name: :index_unique_contract_fittings
    end
  end
end
