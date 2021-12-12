# frozen_string_literal: true

class AddDesiredCountToFittings < ActiveRecord::Migration[6.1]
  def change
    add_column :fittings, :desired_count, :integer
  end
end
