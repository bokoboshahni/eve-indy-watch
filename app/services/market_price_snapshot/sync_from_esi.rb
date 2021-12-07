# frozen_string_literal: true

class MarketPriceSnapshot < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def call # rubocop:disable Metrics/AbcSize
      esi_retriable do
        last_expires = MarketPriceSnapshot.distinct(:esi_expires_at).order('esi_expires_at DESC')&.first&.esi_expires_at
        if last_expires&.> Time.zone.now
          debug("ESI response for market prices is not expired: #{last_expires.iso8601}")
          return
        end

        resp = esi.get_market_prices_raw
        expires = resp.headers['expires']
        last_modified = resp.headers['last-modified']
        data = resp.json

        type_ids = Type.pluck(:id)

        snapshot_attrs = { esi_last_modified_at: last_modified, esi_expires_at: expires }
        snapshots = data.map do |price|
          next unless type_ids.include?(price['type_id'])

          snapshot = snapshot_attrs.merge(price)
          %w[average_price adjusted_price].each { |k| snapshot[k] = nil unless snapshot[k] }
          snapshot
        end

        MarketPriceSnapshot.import!(snapshots.compact, track_validation_failures: true,
                                    on_duplicate_key_update: { conflict_target: %i[id], columns: :all })

        debug("Synced #{snapshots.count} market price snapshots from ESI")
      end
    end
  end
end
