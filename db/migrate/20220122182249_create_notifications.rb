# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :recipient, polymorphic: true, null: false
      t.text :type, null: false
      t.jsonb :params
      t.datetime :read_at, index: true

      t.timestamps null: false
    end
  end
end
