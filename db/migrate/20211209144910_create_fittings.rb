# frozen_string_literal: true

class CreateFittings < ActiveRecord::Migration[6.1]
  def change
    create_table :fittings do |t|
      t.references :owner, polymorphic: true, null: false
      t.references :type, null: false, foreign_key: true

      t.boolean :contract_matching_enabled
      t.datetime :discarded_at, index: true
      t.text :name, null: false
      t.text :original
      t.timestamps null: false
    end

    create_table :fitting_items do |t|
      t.references :fitting, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true

      t.integer :quantity, null: false
    end
  end
end
