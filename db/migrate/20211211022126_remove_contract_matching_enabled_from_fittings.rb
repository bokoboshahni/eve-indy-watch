class RemoveContractMatchingEnabledFromFittings < ActiveRecord::Migration[6.1]
  def change
    remove_column :fittings, :contract_matching_enabled, :boolean
  end
end
