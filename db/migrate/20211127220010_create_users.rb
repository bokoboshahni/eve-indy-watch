class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :alliances do |t|
      t.datetime :esi_expires_at, null: false
      t.datetime :esi_last_modified_at, null: false
      t.text :icon_url_128 # rubocop:disable Naming/VariableNumber
      t.text :icon_url_64 # rubocop:disable Naming/VariableNumber
      t.text :name, null: false
      t.text :ticker, null: false
      t.timestamps null: false
    end

    create_table :corporations do |t|
      t.references :alliance, foreign_key: true

      t.datetime :esi_expires_at, null: false
      t.datetime :esi_last_modified_at, null: false
      t.text :icon_url_128 # rubocop:disable Naming/VariableNumber
      t.text :icon_url_256 # rubocop:disable Naming/VariableNumber
      t.text :icon_url_64 # rubocop:disable Naming/VariableNumber
      t.text :name, null: false
      t.text :ticker, null: false
      t.text :url
      t.timestamps null: false
    end

    create_table :characters do |t|
      t.references :alliance, foreign_key: true
      t.references :corporation, null: false, foreign_key: true

      t.datetime :esi_expires_at, null: false
      t.datetime :esi_last_modified_at, null: false
      t.text :name, null: false
      t.text :portrait_url_128 # rubocop:disable Naming/VariableNumber
      t.text :portrait_url_256 # rubocop:disable Naming/VariableNumber
      t.text :portrait_url_512 # rubocop:disable Naming/VariableNumber
      t.text :portrait_url_64 # rubocop:disable Naming/VariableNumber
      t.timestamps null: false
    end

    create_table :users do |t|
      t.references :character, null: false, foreign_key: true

      t.boolean :admin, null: false, default: false
      t.timestamps null: false
    end

    create_table :esi_authorizations do |t|
      t.references :character, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.text :access_token_ciphertext, null: false
      t.datetime :expires_at, null: false
      t.text :refresh_token_ciphertext, null: false
      t.text :scopes, array: true, null: false, default: []
      t.timestamps null: false
    end
  end
end
