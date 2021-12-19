class Region < ApplicationRecord
  class ImportTypeHistory < ApplicationService
    def initialize(region, type)
      super

      @region = region
      @type = type
    end

    def call
      unless region.type_history_expired?(type)
        debug("Type histories have already been imported for #{type.log_name} in #{region.log_name} on #{Date.today}")
        return
      end

      records = []

      Retriable.retriable tries: 10 do
        req = Typhoeus::Request.new(history_url, params: { type_id: type_id }, headers: default_headers)
        req.on_complete do |res|
          next if res.code != 200

          next if res.body =~ /error/

          next if res.body =~ /\A50\d/

          next if res.body.strip.empty?

          records.push(*Oj.load(res.body).map { |r| r.symbolize_keys!.merge!(region_id: region_id, type_id: type_id) })
        end
        hydra.queue(req)
        hydra.run
      end

      Statistics::RegionTypeHistory.import(
        records,
        validate: false,
        on_duplicate_key_update: {
          conflict_target: %i[region_id type_id date],
          columns: :all
        }
      )

      region
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
