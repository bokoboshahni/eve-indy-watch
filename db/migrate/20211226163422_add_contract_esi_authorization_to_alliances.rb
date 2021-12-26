class AddContractESIAuthorizationToAlliances < ActiveRecord::Migration[6.1]
  def change
    add_reference :alliances, :contract_esi_authorization, foreign_key: { to_table: :esi_authorizations }
  end
end
