class CreateInventoryFlags < ActiveRecord::Migration[6.1]
  def change
    create_table :inventory_flags do |t|
      t.text :name, null: false, index: true
      t.text :text, null: false
      t.integer :order, null: false
      t.timestamps null: false
    end
  end
end
