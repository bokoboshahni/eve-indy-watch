# frozen_string_literal: true

class CreateReportRuns < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL.squish
      CREATE TYPE report_run_status AS ENUM (
        'error',
        'success'
      );
    SQL

    create_table :report_runs do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :user

      t.interval :duration, null: false
      t.jsonb :exception
      t.text :report, null: false
      t.datetime :started_at, null: false
      t.column :status, :report_run_status, null: false
      t.timestamp :created_at, null: false
    end
  end

  def down
    drop_table :report_runs

    execute 'DROP TYPE report_run_status;'
  end
end
