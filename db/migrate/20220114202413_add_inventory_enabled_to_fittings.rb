# frozen_string_literal: true

class AddInventoryEnabledToFittings < ActiveRecord::Migration[6.1]
  def change
    add_column :fittings, :inventory_enabled, :boolean
  end
end
