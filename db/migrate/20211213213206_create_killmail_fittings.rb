class CreateKillmailFittings < ActiveRecord::Migration[6.1]
  def change
    create_table :killmail_fittings, id: false, primary_key: %i[killmail_id fitting_id] do |t|
      t.references :fitting, null: false, foreign_key: true
      t.references :killmail, null: false, foreign_key: true

      t.jsonb :items
      t.decimal :similarity, null: false
      t.timestamps null: false
    end
  end
end
