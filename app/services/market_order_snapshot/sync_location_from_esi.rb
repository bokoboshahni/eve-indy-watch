# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class SyncLocationFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(location)
      super

      @location = location
    end

    def call # rubocop:disable Metrics/AbcSize
      unless location.market_order_sync_enabled
        warn "#{location.class.name} #{location.name} (#{location.id}) does not have market order sync enabled"
      end

      esi_retriable do
        current_expires = location.esi_market_orders_expires_at
        if current_expires&.> Time.zone.now
          debug("ESI response for market orders at #{location.name} (#{location.id}) is not expired: #{current_expires.iso8601}")
          return
        end

        if location.esi_authorization.nil?
          raise Error.new("#{location.class.name} #{location.name} (#{location.id}) has no ESI authorization")
        end

        resps =
          if location.is_a?(Region)
            Retriable.retriable(tries: 10) { esi.get_markets_region_orders_raw(region_id: location.id) }
          elsif location.is_a?(Structure)
            esi_authorize!(location.esi_authorization)
            auth = { Authorization: "Bearer #{location.esi_authorization.access_token}" }
            esi.get_markets_structure_raw(structure_id: location.id, headers: auth)
          end

        first_resp = resps.first
        expires = DateTime.parse(first_resp.headers['expires'])
        last_modified = DateTime.parse(first_resp.headers['last-modified'])
        data = resps.map(&:json).reduce([], :concat)
        debug("Fetched #{data.count} market orders(s) for at #{location.name} (#{location.id})")

        orders = []
        location.transaction do
          location_ids = data.each_with_object(Set.new) do |order, s|
            s.add(order['location_id'])
          end

          locations = {}
          workers = []
          location_ids.to_a.compact.in_groups(16, false) do |batch|
            workers << Thread.new do
              batch.each do |id|
                locations[id] = find_and_sync_location(id, location.esi_authorization)
              end
            end
          end
          workers.each(&:join)
          debug("Synced #{location_ids.count} location(s) from #{data.count} market order(s)")

          type_ids = Type.pluck(:id)

          data.each do |order_data|
            next unless type_ids.include?(order_data['type_id'])

            orders << map_order(order_data, locations, last_modified, expires)
          end

          orders.uniq! { |o| [o[:location_id], o[:order_id]] }
          MarketOrderSnapshot.import!(orders, track_validation_failures: true,
                                     on_duplicate_key_update: { conflict_target: %i[location_id order_id esi_last_modified_at], columns: :all })
          location.update!(esi_market_orders_expires_at: expires, esi_market_orders_last_modified_at: last_modified)
        end

        debug("Synced #{orders.count} market orders(s) for at #{location.name} (#{location.id})")
      end
    end

    private

    attr_reader :authorization, :location

    def map_order(data, locations, last_modified, expires)
      location = locations[data['location_id']]

      {
        duration: data['duration'],
        esi_expires_at: expires,
        esi_last_modified_at: last_modified,
        issued_at: DateTime.parse(data['issued']),
        kind: data['is_buy_order'] ? 'buy' : 'sell',
        location_id: location.id,
        location_type: location.class.name,
        min_volume: data['min_volume'],
        order_id: data['order_id'],
        price: data['price'],
        range: data['range'],
        solar_system_id: location.solar_system_id,
        type_id: data['type_id'],
        volume_remain: data['volume_remain'],
        volume_total: data['volume_total']
      }
    end
  end
end
