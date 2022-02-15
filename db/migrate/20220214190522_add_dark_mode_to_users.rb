# frozen_string_literal: true

class AddDarkModeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :dark_mode_enabled, :boolean
  end
end
