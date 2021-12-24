class AddESIAuthorizationsEnabledToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :esi_authorizations_enabled, :boolean
  end
end
