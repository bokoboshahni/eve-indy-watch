class CreateOrders < ActiveRecord::Migration[6.1]
  def up
    execute <<~SQL
      CREATE TYPE order_range AS ENUM (
        'station',
        'region',
        'solarsystem',
        '1',
        '2',
        '3',
        '4',
        '5',
        '10',
        '20',
        '30',
        '40'
      );
    SQL

    execute <<-SQL
      CREATE TYPE order_status AS ENUM ('active', 'filled', 'deleted');
    SQL

    execute <<-SQL
      CREATE TYPE order_event_action AS ENUM ('create', 'change', 'delete');
    SQL

    execute <<-SQL
      CREATE TYPE order_event_type AS ENUM (
        'unknown',
        'flashed_limit',
        'market',
        'market_limit',
        'resting_limit',
        'pacman'
      )
    SQL

    create_table :orders do |t|
      t.integer :duration, null: false
      t.timestamp :issued_at, null: false
      t.bigint :location_id, null: false, index: true
      t.integer :min_volume, null: false
      t.decimal :price, precision: 15, scale: 2, null: false
      t.column :range, :order_range, null: false
      t.boolean :is_buy_order, null: false
      t.bigint :solar_system_id, null: false, index: true
      t.column :status, :order_status, null: false
      t.bigint :type_id, null: false, index: true
      t.integer :volume_remain, null: false
      t.integer :volume_total, null: false
      t.timestamps null: false
    end

    create_table :order_events, id: false, primary_key: %i[order_id time] do |t|
      t.references :order, null: false
      t.timestamp :time, null: false

      t.column :action, :order_event_action, null: false
      t.column :type, :order_event_type, null: false
      t.integer :fill
      t.decimal :price, precision: 15, scale: 2, null: false
      t.integer :volume, null: false

      t.index %i[order_id time], unique: true, order: { time: :desc }, name: :index_unique_order_events
    end

    # execute "SELECT create_hypertable('order_events', 'time', chunk_time_interval => INTERVAL '1 day');"

    # execute "SELECT add_retention_policy('order_events', interval '1 month');"
  end

  def down
    drop_table :order_events
    drop_table :orders

    execute 'DROP TYPE order_event_type;'
    execute 'DROP TYPE order_event_action;'
    execute 'DROP TYPE order_status;'
    execute 'DROP TYPE order_range;'
  end
end
