class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations, id: false, primary_key: :locatable_id do |t|
      t.references :locatable, polymorphic: true, null: false
      t.text :name, null: false
      t.timestamps null: false

      t.index %i[locatable_id locatable_type], unique: true, name: :index_unique_locations
    end
  end
end
