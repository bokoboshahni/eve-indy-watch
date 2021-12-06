class RenameContractCorporationToAPICorporationOnAlliances < ActiveRecord::Migration[6.1]
  def change
    rename_column :alliances, :api_corporation_id, :api_corporation_id
  end
end
