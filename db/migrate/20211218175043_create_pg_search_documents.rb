class CreatePgSearchDocuments < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pg_trgm'
    enable_extension 'fuzzystrmatch'

    create_table :pg_search_documents do |t|
      t.references :searchable, polymorphic: true, index: true

      t.text :content
      t.timestamps null: false
    end
  end
end
