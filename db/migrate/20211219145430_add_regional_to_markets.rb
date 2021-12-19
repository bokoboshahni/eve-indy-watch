class AddRegionalToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :regional, :boolean
  end
end
