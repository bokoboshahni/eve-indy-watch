# frozen_string_literal: true

class CreateRollups < ActiveRecord::Migration[6.1]
  def change
    create_table :rollups do |t|
      t.text :name, null: false
      t.text :interval, null: false
      t.datetime :time, null: false
      t.jsonb :dimensions, null: false, default: {}
      t.decimal :value

      t.index %i[name interval time dimensions], unique: true, name: :index_unique_rollups
    end
  end
end
