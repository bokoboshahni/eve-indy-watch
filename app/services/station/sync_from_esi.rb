# frozen_string_literal: true

class Station < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(station_id)
      super

      @station_id = station_id
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      expires_key = "locations.#{station_id}.esi_expires"
      last_modified_key = "locations.#{station_id}.esi_last_modified"

      station = Station.find_by(id: station_id)

      if station&.esi_expires_at&.>= Time.zone.now
        logger.debug("ESI response for station (#{station.name}) #{station.id} is not expired: #{station.esi_expires_at.iso8601}")

        if locations_reader.exists(expires_key).zero?
          locations_writer.set(expires_key,
                               struct.esi_expires_at.to_s(:number))
        end
        if locations_reader.exists(last_modified_key).zero?
          locations_writer.set(last_modified_key,
                               struct.esi_last_modified_at.to_s(:number))
        end

        return struct
      end

      station_attrs = station_attrs_from_esi
      station ? station.update!(station_attrs) : station = Station.create!(station_attrs.merge(id: station_id))

      location = Location.find_by(locatable_id: station.id)
      location ? location.update!(name: station.name) : Location.create!(locatable: station, name: station.name)

      locations_writer.set(expires_key, station.esi_expires_at.to_s(:number))
      locations_writer.set(last_modified_key, station.esi_last_modified_at.to_s(:number))

      debug("Synced station #{station_id} from ESI")
      station
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync station #{station_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :station_id

    def station_attrs_from_esi
      resp = esi.get_universe_station_raw(station_id: station_id)
      expires = DateTime.parse(resp.headers['expires'])
      last_modified = DateTime.parse(resp.headers['last-modified'])
      data = resp.json

      Corporation::SyncFromESI.call(data['owner'])

      {
        esi_expires_at: expires,
        esi_last_modified_at: last_modified,
        id: station_id,
        owner_id: data['owner'],
        name: data['name'],
        solar_system_id: data['system_id'],
        type_id: data['type_id']
      }
    end
  end
end
