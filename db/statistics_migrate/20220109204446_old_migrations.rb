# frozen_string_literal: true

class OldMigrations < ActiveRecord::Migration[6.1]
  REQUIRED_VERSION = 20_220_109_204_446

  def up
    return unless ActiveRecord::Migrator.current_version < REQUIRED_VERSION

    raise StandardError, '`bin/rails db:schema:load:statistics` must be run prior to `rails db:migrate`'
  end
end
