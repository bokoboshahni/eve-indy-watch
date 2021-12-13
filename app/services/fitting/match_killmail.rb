class Fitting < ApplicationRecord
  class MatchKillmail < ApplicationService
    def initialize(fitting, killmail)
      super

      @fitting = fitting
      @killmail = killmail
    end

    def call
      debug "Fitting items: #{fitting_item_ids.sort}"
      debug "Killmail items: #{killmail_item_ids.sort}"

      missing_items = fitting_item_ids - killmail_item_ids
      debug "Missing items: #{missing_items}"

      similarity = missing_items.count.to_d / fitting_item_ids.count.to_d

      {
        items: killmail_item_ids,
        similarity: similarity
      }
    end

    private

    attr_reader :fitting, :killmail

    delegate :id, to: :killmail, prefix: true

    def fitting_items
      fitting.compact_items
    end

    def fitting_item_ids
      fitting_items.keys
    end

    def killmail_items
      killmail.fitting_items
    end

    def killmail_item_ids
      killmail_items.keys
    end
  end
end
