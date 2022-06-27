# frozen_string_literal: true

class Alliance < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    def initialize(alliance_id)
      super

      @alliance_id = alliance_id
    end

    def call
      with_retries(on: [ActiveRecord::RecordNotUnique], tries: 10) do
        alliance = Alliance.find_by(id: alliance_id)
        if alliance&.esi_expires_at&.>= Time.zone.now
          logger.debug("ESI response for alliance (#{alliance.name}) #{alliance.id} is not expired: #{alliance.esi_expires_at.iso8601}")
          return alliance
        end

        alliance_attrs = alliance_attrs_from_esi
        alliance_attrs.merge!(alliance_icon_attrs_from_esi)
        alliance.present? ? alliance.update!(alliance_attrs) : alliance = Alliance.create!(alliance_attrs.merge(id: alliance_id))

        debug("Synced alliance #{alliance_id} from ESI")
        alliance
      end
    end

    private

    attr_reader :alliance_id

    def alliance_attrs_from_esi
      resp = esi.get_alliance_raw(alliance_id:)
      expires = DateTime.parse(resp.headers['expires'])
      last_modified = DateTime.parse(resp.headers['last-modified'])
      data = Oj.load(resp.body)

      {
        esi_expires_at: expires,
        esi_last_modified_at: last_modified,
        name: data['name'],
        ticker: data['ticker']
      }
    end

    def alliance_icon_attrs_from_esi
      data = esi.get_alliance_icons(alliance_id:)

      {
        icon_url_128: data['px128x128'], # rubocop:disable Naming/VariableNumber
        icon_url_64: data['px64x64'] # rubocop:disable Naming/VariableNumber
      }
    end
  end
end
