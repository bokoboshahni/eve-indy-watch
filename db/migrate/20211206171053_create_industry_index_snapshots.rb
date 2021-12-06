class CreateIndustryIndexSnapshots < ActiveRecord::Migration[6.1]
  def change
    create_table :industry_index_snapshots do |t|
      t.references :solar_system, null: false, foreign_key: true

      t.decimal :copying
      t.decimal :duplicating
      t.decimal :invention
      t.decimal :manufacturing
      t.decimal :none
      t.decimal :reaction
      t.decimal :researching_material_efficiency
      t.decimal :researching_technology
      t.decimal :researching_time_efficiency
      t.decimal :reverse_engineering
      t.datetime :esi_expires_at, null: false
      t.datetime :esi_last_modified_at, null: false

      t.index %i[solar_system_id esi_last_modified_at], unique: true, name: :index_unique_industry_index_snapshots
    end
  end
end
