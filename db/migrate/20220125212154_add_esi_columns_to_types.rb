# frozen_string_literal: true

class AddESIColumnsToTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :types, :esi_last_modified_at, :datetime
    add_column :types, :esi_expires_at, :datetime
  end
end
