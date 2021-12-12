# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class ImportFromESI < ApplicationService
    include ESIHelpers

    def initialize(location, expires, last_modified, data)
      super

      @location = location
      @last_modified = last_modified
      @expires = expires
      @data = data
    end

    def call
      orders = data.each_with_object([]) { |o, a| a << map_order(o) }
      orders.uniq! { |o| [o[:location_id], o[:order_id]] }

      MarketOrderSnapshot.import!(
        orders,
        track_validation_failures: true,
        on_duplicate_key_update: { conflict_target: %i[location_id order_id esi_last_modified_at], columns: :all }
      )

      debug("Processed #{orders.count} market orders(s) for #{location.name} (#{location.id})")
    end

    private

    attr_reader :location, :last_modified, :expires, :data

    def map_order(data)
      order = data.symbolize_keys
      order[:kind] = order.delete(:is_buy_order) ? 'buy' : 'sell'
      order[:location_type] = location_type(order[:location_id])
      order[:issued_at] = order.delete(:issued)
      order[:esi_expires_at] = expires
      order[:esi_last_modified_at] = last_modified
      order[:solar_system_id] = location.is_a?(Structure) ? location.solar_system_id : order.delete(:system_id)
      order
    end
  end
end
