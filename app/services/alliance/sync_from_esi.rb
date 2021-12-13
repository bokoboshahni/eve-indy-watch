# frozen_string_literal: true

class Alliance < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(alliance_id)
      super

      @alliance_id = alliance_id
    end

    def call # rubocop:disable Metrics/AbcSize
      Retriable.retriable on: [ActiveRecord::RecordNotUnique], tries: 10 do
        alliance = Alliance.find_by(id: alliance_id)
        if alliance&.esi_expires_at&.>= Time.zone.now
          logger.debug("ESI response for alliance (#{alliance.name}) #{alliance.id} is not expired: #{alliance.esi_expires_at.iso8601}") # rubocop:disable Metrics/LineLength
          return alliance
        end

        alliance_attrs = alliance_attrs_from_esi
        alliance_attrs.merge!(alliance_icon_attrs_from_esi)
        alliance.present? ? alliance.update!(alliance_attrs) : alliance = Alliance.create!(alliance_attrs.merge(id: alliance_id)) # rubocop:disable Metrics/LineLength

        debug("Synced alliance #{alliance_id} from ESI")
        alliance
      end
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync alliance #{alliance_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :alliance_id

    def alliance_attrs_from_esi
      esi_retriable do
        resp = esi.get_alliance_raw(alliance_id: alliance_id)
        expires = DateTime.parse(resp.headers['expires'])
        last_modified = DateTime.parse(resp.headers['last-modified'])
        data = resp.json

        {
          esi_expires_at: expires,
          esi_last_modified_at: last_modified,
          name: data['name'],
          ticker: data['ticker']
        }
      end
    end

    def alliance_icon_attrs_from_esi
      esi_retriable do
        data = esi.get_alliance_icons(alliance_id: alliance_id)

        {
          icon_url_128: data['px128x128'], # rubocop:disable Naming/VariableNumber
          icon_url_64: data['px64x64'] # rubocop:disable Naming/VariableNumber
        }
      end
    end
  end
end
