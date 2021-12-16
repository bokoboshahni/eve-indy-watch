class RenameDesiredCountToSafetyStock < ActiveRecord::Migration[6.1]
  def change
    rename_column :fittings, :desired_count, :safety_stock
  end
end
