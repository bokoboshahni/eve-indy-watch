class AddPrivateToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :private, :boolean
  end
end
