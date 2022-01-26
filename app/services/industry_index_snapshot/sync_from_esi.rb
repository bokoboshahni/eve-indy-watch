# frozen_string_literal: true

class IndustryIndexSnapshot < ApplicationRecord
  class SyncFromESI < ApplicationService
    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      last_expires = IndustryIndexSnapshot.distinct(:esi_expires_at).order('esi_expires_at DESC')&.first&.esi_expires_at
      if last_expires&.> Time.zone.now
        debug("ESI response for industry indices is not expired: #{last_expires.iso8601}")
        return
      end

      resp = esi.get_industry_systems_raw
      expires = resp.headers['expires']
      last_modified = resp.headers['last-modified']
      data = Oj.load(resp.body)

      snapshot_attrs = { esi_last_modified_at: last_modified, esi_expires_at: expires }
      snapshots = data.map do |system|
        next unless SolarSystem.exists?(system['solar_system_id'])

        snapshot = snapshot_attrs.merge('solar_system_id' => system['solar_system_id'])
        system['cost_indices'].each do |index|
          snapshot[(index['activity']).to_s] = index['cost_index']
        end

        %w[
          copying duplicating invention manufacturing none reaction
          researching_material_efficiency researching_technology researching_time_efficiency reverse_engineering
        ].each { |k| snapshot[k] = nil unless snapshot[k] }

        snapshot
      end

      IndustryIndexSnapshot.import!(snapshots.compact, track_validation_failures: true,
                                                       on_duplicate_key_update: { conflict_target: %i[id], columns: :all })

      debug("Synced #{snapshots.count} industry index snapshots from ESI")
    end
  end
end
