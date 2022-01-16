# frozen_string_literal: true

class CreateAhoyTables < ActiveRecord::Migration[6.1]
  def change
    create_table :ahoy_visits do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.text :browser
      t.text :device_type
      t.text :ip
      t.text :landing_page
      t.text :os
      t.text :referrer
      t.text :referring_domain
      t.datetime :started_at
      t.text :user_agent
      t.text :visit_token, index: { unique: true, name: :index_unique_visit_tokens }
      t.text :visitor_token
    end

    create_table :ahoy_events do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :visit
      t.text :name
      t.jsonb :properties, index: { using: :gin }
      t.timestamp :time
    end
  end
end
