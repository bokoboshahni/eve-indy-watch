# frozen_string_literal: true

class AddPinnedToFittings < ActiveRecord::Migration[6.1]
  def change
    add_column :fittings, :pinned, :boolean
  end
end
