class AddOfflineToFittingItems < ActiveRecord::Migration[6.1]
  def change
    add_column :fitting_items, :offline, :boolean
  end
end
