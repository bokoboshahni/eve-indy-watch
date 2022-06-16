# frozen_string_literal: true

class AddSecondaryMarketIDToAlliances < ActiveRecord::Migration[7.0]
  def change
    add_reference :alliances, :secondary_market
  end
end
