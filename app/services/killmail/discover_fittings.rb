# frozen_string_literal: true

class Killmail < ApplicationRecord
  class DiscoverFittings < ApplicationService
    def initialize(killmail)
      super

      @killmail = killmail
    end

    def call
      ship_id = killmail.ship_type_id
      candidates = Fitting.includes(:items).where(type_id: ship_id)
      killmail.transaction do
        matches = candidates.map do |fitting|
          match_info = Fitting::MatchKillmail.call(fitting, killmail)

          kf = killmail.killmail_fittings.find_or_initialize_by(fitting_id: fitting.id)
          kf.attributes = kf.attributes.merge(match_info)
          kf.save!
        end

        debug "Scored #{matches.count} fittings for killmail #{killmail.id}"
      end
    end

    private

    attr_reader :killmail
  end
end
