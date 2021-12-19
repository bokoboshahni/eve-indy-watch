class AddTypeHistoryPreloadEnabledToRegions < ActiveRecord::Migration[6.1]
  def change
    add_column :regions, :type_history_preload_enabled, :boolean
  end
end
