# frozen_string_literal: true

class CreateVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :versions do |t|
      t.references :item, polymorphic: true, null: false

      t.datetime :created_at
      t.text :event, null: false
      t.text :whodunnit
      t.jsonb :object
      t.jsonb :object_changes
    end
  end
end
