# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(corporation_id)
      super

      @corporation_id = corporation_id
    end

    def call
      corporation = Corporation.find_by(id: corporation_id)
      if corporation&.esi_expires_at&.>= Time.zone.now
        logger.debug("ESI response for corporation (#{corporation.name}) #{corporation.id} is not expired: #{corporation.esi_expires_at.iso8601}")
        return corporation
      end

      corporation_attrs = corporation_attrs_from_esi
      corporation_attrs.merge!(corporation_icon_attrs_from_esi)
      corporation.present? ? corporation.update!(corporation_attrs) : corporation = Corporation.create!(corporation_attrs.merge(id: corporation_id))
      corporation
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync corporation #{corporation_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :corporation_id

    def corporation_attrs_from_esi
      resp = esi.get_corporation_raw(corporation_id: corporation_id)
      expires = DateTime.parse(resp.headers['expires'])
      last_modified = DateTime.parse(resp.headers['last-modified'])
      data = resp.json

      {
        alliance_id: data['alliance_id'],
        esi_expires_at: expires,
        esi_last_modified_at: last_modified,
        name: data['name'],
        ticker: data['ticker'],
        url: data['url']
      }
    end

    def corporation_icon_attrs_from_esi
      data = esi.get_corporation_icons(corporation_id: corporation_id)

      {
        icon_url_128: data['px128x128'], # rubocop:disable Naming/VariableNumber
        icon_url_256: data['px256x256'], # rubocop:disable Naming/VariableNumber
        icon_url_64: data['px64x64'] # rubocop:disable Naming/VariableNumber
      }
    end
  end
end
