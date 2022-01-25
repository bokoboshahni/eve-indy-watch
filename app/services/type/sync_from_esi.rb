# frozen_string_literal: true

class Type < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(type_id, ignore_not_found: false)
      super

      @type_id = type_id
      @ignore_not_found = ignore_not_found
    end

    def call
      type = Type.find_by(id: type_id)

      if type&.esi_expires_at&.>= Time.zone.now
        logger.debug("ESI response for type (#{type.name}) #{type.id} is not expired: #{type.esi_expires_at.iso8601}")
        return type
      end

      type_attrs = type_attrs_from_esi

      Group::SyncFromESI.call(type_attrs[:group_id]) unless Group.exists?(type_attrs[:group_id])

      type ? type.update!(type_attrs) : type = Type.create!(type_attrs.merge(id: type_id))

      debug("Synced type #{type_id} from ESI")
      type
    rescue ESI::Errors::ClientError => e
      if e.message.include?('Not found') && ignore_not_found
        error("Type #{type_id} not found on ESI")
        return
      end

      msg = "Unable to sync type #{type_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :type_id, :ignore_not_found

    def type_attrs_from_esi
      resp = esi.get_universe_type_raw(type_id: type_id)
      expires = DateTime.parse(resp.headers['expires'])
      last_modified = DateTime.parse(resp.headers['last-modified'])
      data = resp.json

      {
        esi_expires_at: expires,
        esi_last_modified_at: last_modified,
        description: data['description'],
        id: type_id,
        name: data['name'],
        packaged_volume: data['packaged_volume'],
        volume: data['volume'],
        group_id: data['group_id'],
        market_group_id: data['market_group_id'],
        portion_size: data['portion_size']
      }
    end
  end
end
