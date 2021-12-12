# frozen_string_literal: true

class CreateMarkets < ActiveRecord::Migration[6.1]
  def change
    create_table :markets do |t|
      t.references :owner, polymorphic: true

      t.text :name, null: false
      t.timestamps null: false
    end

    create_table :market_locations, id: false, primary_key: %i[market_id location_id location_type] do |t|
      t.references :market, null: false, foreign_key: true
      t.references :location, polymorphic: true, null: false

      t.timestamps null: false
    end
  end
end
