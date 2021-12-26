class RemoveContractESIAuthorizationIDFromAlliances < ActiveRecord::Migration[6.1]
  def change
    remove_reference :alliances, :contract_esi_authorization
  end
end
