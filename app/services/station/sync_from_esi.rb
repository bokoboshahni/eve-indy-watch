# frozen_string_literal: true

class Station < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(station_id)
      super

      @station_id = station_id
    end

    def call
      station = Station.find_by(id: station_id)

      station_attrs = station_attrs_from_esi
      station ? station.update!(station_attrs) : station = Station.create!(station_attrs.merge(id: station_id))

      debug("Synced station #{station_id} from ESI")
      station
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync station #{station_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :station_id

    def station_attrs_from_esi
      data = esi.get_universe_station(station_id: station_id)

      Corporation::SyncFromESI.call(data['owner'])

      {
        id: station_id,
        owner_id: data['owner'],
        name: data['name'],
        solar_system_id: data['system_id'],
        type_id: data['type_id']
      }
    end
  end
end
