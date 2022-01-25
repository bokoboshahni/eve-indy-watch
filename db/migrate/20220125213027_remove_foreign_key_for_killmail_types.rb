# frozen_string_literal: true

class RemoveForeignKeyForKillmailTypes < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :killmails, :types, column: :ship_type_id
    remove_foreign_key :killmail_items, :types, column: :type_id
    remove_foreign_key :killmail_attackers, :types, column: :ship_type_id
    remove_foreign_key :killmail_attackers, :types, column: :weapon_type_id
  end
end
