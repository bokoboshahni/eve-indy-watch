# frozen_string_literal: true

class AddProcurementOrderRequesterToCorporations < ActiveRecord::Migration[6.1]
  def change
    add_reference :corporations, :procurement_order_requester, polymorphic: true
  end
end
