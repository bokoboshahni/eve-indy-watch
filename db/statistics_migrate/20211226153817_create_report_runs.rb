# frozen_string_literal: true

class CreateReportRuns < ActiveRecord::Migration[6.1]
  def change
    create_table :report_runs do |t|
      t.text :report, index: true, null: false
      t.references :user, index: true
      t.interval :duration, null: false
      t.text :status, null: false
      t.jsonb :exception
      t.datetime :started_at, null: false
      t.datetime :created_at, null: false
    end
  end
end
