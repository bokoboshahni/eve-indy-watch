class AddActiveToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :active, :boolean
  end
end
