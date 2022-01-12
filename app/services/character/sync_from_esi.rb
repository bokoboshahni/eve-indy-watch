# frozen_string_literal: true

class Character < ApplicationRecord
  class SyncFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(character_id)
      super

      @character_id = character_id
    end

    def call
      Retriable.retriable on: [ActiveRecord::RecordNotUnique], tries: 10 do
        char = Character.find_by(id: character_id)
        if char&.esi_expires_at&.>= Time.zone.now
          logger.debug("ESI response for character (#{char.name}) #{char.id} is not expired: #{char.esi_expires_at.iso8601}")
          return char
        end

        char_attrs = character_attrs_from_esi
        char_attrs.merge!(portrait_attrs_from_esi)
        sync_alliance!(char_attrs[:alliance_id])
        sync_corporation!(char_attrs[:corporation_id])

        char ? char.update!(char_attrs) : char = Character.create!(char_attrs.merge(id: character_id))

        debug("Synced character #{character_id} from ESI")
        char
      end
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync character #{character_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :character_id

    def character_attrs_from_esi
      esi_retriable do
        resp = esi.get_character_raw(character_id: character_id)
        expires = DateTime.parse(resp.headers['expires'])
        last_modified = DateTime.parse(resp.headers['last-modified'])
        data = resp.json

        {
          alliance_id: data['alliance_id']&.to_i,
          corporation_id: data['corporation_id']&.to_i,
          esi_expires_at: expires,
          esi_last_modified_at: last_modified,
          name: data['name']
        }
      end
    end

    def portrait_attrs_from_esi
      esi_retriable do
        data = esi.get_character_portrait(character_id: character_id)

        {
          portrait_url_128: data['px128x128'], # rubocop:disable Naming/VariableNumber
          portrait_url_256: data['px256x256'], # rubocop:disable Naming/VariableNumber
          portrait_url_512: data['px512x512'], # rubocop:disable Naming/VariableNumber
          portrait_url_64: data['px64x64'] # rubocop:disable Naming/VariableNumber
        }
      end
    end

    def sync_alliance!(alliance_id)
      return if alliance_id.blank?

      Alliance::SyncFromESI.call(alliance_id)
    end

    def sync_corporation!(corporation_id)
      Corporation::SyncFromESI.call(corporation_id)
    end
  end
end
