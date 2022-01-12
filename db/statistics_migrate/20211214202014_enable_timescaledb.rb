# frozen_string_literal: true

class EnableTimescaledb < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'timescaledb'
  end
end
