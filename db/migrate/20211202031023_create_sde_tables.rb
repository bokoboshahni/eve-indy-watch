# frozen_string_literal: true

class CreateSDETables < ActiveRecord::Migration[6.1]
  def change
    create_table :regions do |t|
      t.text :name, null: false
      t.timestamps null: false
    end

    create_table :constellations do |t|
      t.references :region, null: false, foreign_key: true

      t.text :name, null: false
      t.timestamps null: false
    end

    create_table :solar_systems do |t|
      t.references :constellation, null: false, foreign_key: true

      t.text :name, null: false
      t.decimal :security, null: false
      t.timestamps null: false
    end

    create_table :categories do |t|
      t.text :name, null: false
      t.boolean :published, null: false
      t.timestamps null: false
    end

    create_table :groups do |t|
      t.references :category, null: false, foreign_key: true

      t.text :name, null: false
      t.boolean :published, null: false
      t.timestamps null: false
    end

    create_table :market_groups do |t|
      t.text :ancestry, index: { order: { ancestry: :text_pattern_ops } }
      t.integer :ancestry_depth
      t.text :description, null: false
      t.text :name, null: false
      t.integer :parent_id
      t.timestamps null: false
    end

    create_table :types do |t|
      t.references :group, null: false, foreign_key: true
      t.references :market_group, foreign_key: true

      t.text :description
      t.text :name, null: false
      t.decimal :packaged_volume
      t.integer :portion_size
      t.boolean :published
      t.decimal :volume
      t.timestamps null: false
    end

    create_table :stations do |t|
      t.references :owner, null: false, foreign_key: { to_table: :corporations }
      t.references :solar_system, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true

      t.text :name, null: false
      t.timestamps null: false
    end

    create_table :structures do |t|
      t.references :owner, foreign_key: { to_table: :corporations }
      t.references :solar_system, foreign_key: true
      t.references :type, foreign_key: true

      t.datetime :esi_expires_at
      t.datetime :esi_last_modified_at
      t.text :name, null: false
      t.timestamps null: false
    end
  end
end
