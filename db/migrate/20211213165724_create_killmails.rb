class CreateKillmails < ActiveRecord::Migration[6.1]
  def change
    add_column :alliances, :zkb_fetched_at, :datetime
    add_column :alliances, :zkb_sync_enabled, :boolean

    create_table :killmails do |t|
      t.references :alliance, foreign_key: true
      t.references :character, foreign_key: true
      t.references :corporation, foreign_key: true
      t.references :ship_type, null: false, foreign_key: { to_table: :types }
      t.references :solar_system, foreign_key: true

      t.boolean :awox, null: false
      t.datetime :created_at, null: false
      t.integer :damage_taken, null: false
      t.bigint :faction_id
      t.text :killmail_hash, null: false
      t.bigint :moon_id
      t.boolean :npc, null: false
      t.integer :points, null: false
      t.decimal :position_x, null: false
      t.decimal :position_y, null: false
      t.decimal :position_z, null: false
      t.boolean :solo, null: false
      t.datetime :time, null: false
      t.bigint :war_id
      t.decimal :zkb_dropped_value, null: false
      t.decimal :zkb_destroyed_value, null: false
      t.decimal :zkb_total_value, null: false
    end

    create_table :killmail_attackers do |t|
      t.references :alliance, foreign_key: true
      t.references :character, foreign_key: true
      t.references :corporation, foreign_key: true
      t.references :killmail, null: false, foreign_key: true
      t.references :ship_type, foreign_key: { to_table: :types }
      t.references :weapon_type, foreign_key: { to_table: :types }

      t.integer :damage_done, null: false
      t.bigint :faction_id
      t.boolean :final_blow, null: false
      t.decimal :security_status, null: false
    end

    create_table :killmail_items do |t|
      t.references :killmail, null: false, foreign_key: true
      t.references :type, foreign_key: true

      t.text :ancestry, index: { order: { ancestry: :text_pattern_ops } }
      t.integer :ancestry_depth
      t.text :flag
      t.bigint :quantity_destroyed
      t.bigint :quantity_dropped
      t.integer :singleton, null: false
    end
  end
end
