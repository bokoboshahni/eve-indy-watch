# frozen_string_literal: true

class Region < ApplicationRecord
  class ImportTypeHistory < ApplicationService
    def initialize(region, type)
      super

      @region = region
      @type = type
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      unless region.type_history_expired?(type)
        debug("Type histories have already been imported for #{type.log_name} in #{region.log_name} on #{Time.zone.today}")
        return
      end

      records = []

      Retriable.retriable tries: 10, base_interval: 1.0, multiplier: 2.0 do
        req = Typhoeus::Request.new(history_url, params: { type_id: type_id }, headers: default_headers)
        req.on_complete do |res|
          next if res.code == 404

          raise "##{res.code}: #{res.body}" if res.code != 200

          raise "##{res.code}: #{res.body}" if /error/.match?(res.body)

          raise "##{res.code}: #{res.body}" if /\A50\d/.match?(res.body)

          raise "##{res.code}: (empty body)" if res.body.strip.empty?

          records.push(*Oj.load(res.body).map { |r| r.symbolize_keys!.merge!(region_id: region_id, type_id: type_id) })
        end
        hydra.queue(req)
        hydra.run
      end

      return if records.empty?

      RegionTypeHistory.import(
        records,
        validate: false,
        on_duplicate_key_update: {
          conflict_target: %i[region_id type_id date],
          columns: :all
        }
      )

      records
    end

    private

    attr_reader :region, :type

    delegate :id, to: :region, prefix: true
    delegate :id, to: :type, prefix: true

    def history_url
      "https://esi.evetech.net/latest/markets/#{region_id}/history"
    end
  end
end
