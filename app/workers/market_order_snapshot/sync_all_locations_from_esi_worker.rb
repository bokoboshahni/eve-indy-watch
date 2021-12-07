# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class SyncAllLocationsFromESIWorker < ApplicationWorker
    sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: { client: :log, server: :log }

    def perform
      [
        Structure.where(market_order_sync_enabled: true).where('esi_market_orders_expires_at <= ?', Time.zone.now)
                 .or(Structure.where(esi_market_orders_last_modified_at: nil, market_order_sync_enabled: true)),
        Region.where(market_order_sync_enabled: true).where('esi_market_orders_expires_at <= ?', Time.zone.now)
              .or(Region.where(esi_market_orders_last_modified_at: nil, market_order_sync_enabled: true))
      ].flatten.each do |location|
        MarketOrderSnapshot.sync_location_from_esi_async(location)
      end
    end
  end
end
