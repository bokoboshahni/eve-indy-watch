# frozen_string_literal: true

class AddESIAuthorizationIDToCorporations < ActiveRecord::Migration[6.1]
  def change
    add_column :corporations, :esi_authorization_id, :integer
    add_index :corporations, :esi_authorization_id
    add_foreign_key :corporations, :esi_authorizations
  end
end
