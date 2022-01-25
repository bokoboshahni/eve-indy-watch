# frozen_string_literal: true

class AddESIColumnsToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :esi_last_modified_at, :datetime
    add_column :groups, :esi_expires_at, :datetime
  end
end
