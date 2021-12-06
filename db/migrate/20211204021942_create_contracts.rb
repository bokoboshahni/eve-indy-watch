# frozen_string_literal: true

class CreateContracts < ActiveRecord::Migration[6.1]
  def change
    create_table :contracts do |t|
      t.references :acceptor, polymorphic: true
      t.references :assignee, polymorphic: true, null: false
      t.references :end_location, polymorphic: true
      t.references :issuer, null: false, foreign_key: { to_table: :characters }
      t.references :issuer_corporation, null: false, foreign_key: { to_table: :corporations }
      t.references :start_location, polymorphic: true

      t.datetime :accepted_at
      t.text :availability, null: false
      t.decimal :buyout
      t.decimal :collateral
      t.datetime :completed_at
      t.integer :days_to_complete
      t.datetime :esi_expires_at, null: false
      t.jsonb :esi_items_exception
      t.datetime :esi_items_expires_at
      t.datetime :esi_items_last_modified_at
      t.datetime :esi_last_modified_at, null: false
      t.datetime :expired_at, null: false
      t.boolean :for_corporation
      t.datetime :issued_at, null: false
      t.decimal :price
      t.decimal :reward
      t.text :status, null: false, index: true
      t.text :title, index: true
      t.text :type, null: false, index: true
      t.decimal :volume
      t.timestamps null: false
    end

    create_table :contract_items do |t|
      t.references :contract, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: { to_table: :types }

      t.boolean :is_included, null: false
      t.boolean :is_singleton, null: false
      t.integer :quantity, null: false
      t.integer :raw_quantity
      t.timestamps null: false
    end

    create_table :contract_versions do |t|
      t.references :item, null: false, polymorphic: true

      t.datetime :created_at, null: false
      t.text :event, null: false
      t.text :whodunnit
      t.jsonb :object
      t.jsonb :object_changes
    end

    create_table :contract_events do |t|
      t.references :alliance, foreign_key: true
      t.references :contract, null: false, foreign_key: true
      t.references :corporation, null: false, foreign_key: true

      t.decimal :collateral
      t.text :event, null: false
      t.decimal :price
      t.decimal :reward
      t.datetime :time, null: false
    end

    add_column :corporations, :esi_contracts_expires_at, :datetime
    add_column :corporations, :esi_contracts_last_modified_at, :datetime
    add_column :corporations, :contract_sync_enabled, :boolean

    add_column :alliances, :api_corporation_id, :bigint, index: true
  end
end
