# frozen_string_literal: true

class CreateAllianceLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :alliance_locations, id: false, primary_key: %i[alliance_id location_id] do |t|
      t.references :alliance, null: false
      t.references :location, null: false

      t.boolean :default

      t.index %i[alliance_id location_id], unique: true, name: :index_unique_alliance_locations
    end

    add_reference :alliances, :procurement_order_assignee, polymorphic: true
  end
end
