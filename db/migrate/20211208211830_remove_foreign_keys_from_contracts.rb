# frozen_string_literal: true

class RemoveForeignKeysFromContracts < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :contracts, :characters, column: :issuer_id
    remove_foreign_key :contracts, :corporations, column: :issuer_corporation_id
  end
end
