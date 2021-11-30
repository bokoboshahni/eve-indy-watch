# frozen_string_literal: true

class AddNpcToCorporations < ActiveRecord::Migration[6.1]
  def change
    add_column :corporations, :npc, :boolean
  end
end
