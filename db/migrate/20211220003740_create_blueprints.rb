class CreateBlueprints < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      CREATE TYPE blueprint_activity AS ENUM (
        'copying',
        'invention',
        'manufacturing',
        'research_material',
        'research_time',
        'reaction'
      )
    SQL

    add_column :types, :max_production_limit, :integer

    create_table :blueprint_activities, id: false, primary_key: %i[blueprint_type_id activity] do |t|
      t.references :blueprint_type, null: false
      t.column :activity, :blueprint_activity, null: false

      t.integer :time, null: false
      t.timestamps null: false

      t.index %i[blueprint_type_id activity], unique: true, name: :index_unique_blueprint_activities
    end

    create_table :blueprint_materials, id: false, primary_key: %i[blueprint_type_id material_type_id activity] do |t|
      t.references :blueprint_type, null: false
      t.references :material_type, null: false
      t.column :activity, :blueprint_activity, null: false

      t.integer :quantity, null: false
      t.timestamps null: false

      t.index %i[blueprint_type_id material_type_id activity], unique: true, name: :index_unique_blueprint_materials
    end

    create_table :blueprint_products, id: false, primary_key: %i[blueprint_type_id product_type_id activity] do |t|
      t.references :blueprint_type, null: false
      t.references :product_type, null: false
      t.column :activity, :blueprint_activity, null: false

      t.integer :quantity, null: false
      t.timestamps null: false

      t.index %i[blueprint_type_id product_type_id activity], unique: true, name: :index_unique_blueprint_products
    end

    create_table :blueprint_skills, id: false, primary_key: %i[blueprint_type_id skill_type_id activity] do |t|
      t.references :blueprint_type, null: false
      t.references :skill_type, null: false
      t.column :activity, :blueprint_activity, null: false

      t.integer :level, null: false
      t.timestamps null: false

      t.index %i[blueprint_type_id skill_type_id activity], unique: true, name: :index_unique_blueprint_skills
    end
  end

  def down
    drop_table :blueprint_skills
    drop_table :blueprint_products
    drop_table :blueprint_materials
    drop_table :blueprint_activities

    remove_column :types, :max_production_limit, :integer

    execute 'DROP TYPE blueprint_activity;'
  end
end
