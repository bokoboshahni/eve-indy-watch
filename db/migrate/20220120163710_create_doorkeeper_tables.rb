# frozen_string_literal: true

class CreateDoorkeeperTables < ActiveRecord::Migration[6.1]
  def change
    create_table :oauth_applications do |t|
      t.references :owner, polymorphic: true

      t.boolean :personal, null: false, default: false
      t.boolean :confidential, null: false, default: true
      t.text :name, null: false
      t.text :redirect_uri
      t.text :scopes, null: false, default: ''
      t.text :secret, null: false
      t.text :uid, null: false, index: { unique: true, name: :index_unique_oauth_application_uids }
      t.timestamps null: false
    end

    create_table :oauth_access_grants do |t|
      t.references :application, null: false, foreign_key: { to_table: :oauth_applications }
      t.references :resource_owner, null: false, foreign_key: { to_table: :users }

      t.datetime :created_at, null: false
      t.integer :expires_in, null: false
      t.text :redirect_uri, null: false
      t.datetime :revoked_at
      t.text :scopes, null: false, default: ''
      t.string :token, null: false, index: { unique: true, name: :index_unique_oauth_access_grant_tokens }
    end

    create_table :oauth_access_tokens do |t|
      t.references :resource_owner, null: false, index: true, foreign_key: { to_table: :users }
      t.references :application, null: false, foreign_key: { to_table: :oauth_applications }

      t.datetime :created_at, null: false
      t.text :description
      t.integer :expires_in
      t.text :refresh_token, index: { unique: true, name: :index_unique_oauth_refresh_tokens }
      t.datetime :revoked_at
      t.text :scopes
      t.text :token, null: false, index: { unique: true, name: :index_unique_oauth_access_tokens }
    end
  end
end
