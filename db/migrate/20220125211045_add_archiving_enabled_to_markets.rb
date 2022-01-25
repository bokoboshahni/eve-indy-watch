# frozen_string_literal: true

class AddArchivingEnabledToMarkets < ActiveRecord::Migration[6.1]
  def change
    add_column :markets, :archiving_enabled, :boolean
  end
end
