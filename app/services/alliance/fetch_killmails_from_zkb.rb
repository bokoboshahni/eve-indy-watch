# frozen_string_literal: true

class Alliance < ApplicationRecord
  class FetchKillmailsFromZKB < ApplicationService
    def initialize(alliance, year: nil, month: nil)
      super

      @alliance = alliance
      @year = year
      @month = month
    end

    def call
      Retriable.retriable on: [Oj::ParseError], tries: 10 do
        killmails = []
        page_count = 1
        loop do
          url = "#{base_url}/#{page_count}/"
          resp = zkb.get(url)
          resp.raise_for_status
          data = resp.json

          break if data.empty?

          debug "Parsed #{data.count} killmail(s) from #{url}"

          killmails.push(*data)
          page_count += 1

          break if data.count < 200

          sleep(10)
        end
        killmails
      end
    end

    private

    ZKB_BASE_URL = 'https://zkillboard.com/api'

    attr_reader :alliance, :year, :month

    delegate :id, to: :alliance, prefix: true

    def base_url
      "#{ZKB_BASE_URL}/allianceID/#{alliance_id}/#{date_param}/page"
    end

    def date_param
      return 'pastSeconds/3600' unless year && month

      "year/#{year}/month/#{month}"
    end

    def headers
      @headers ||= { 'User-Agent' => esi_config.user_agent }
    end

    def zkb
      @zkb ||= HTTPX.with(origin: base_url)
                    .with_headers(headers)
                    .plugin(:persistent)
                    .plugin(:response_cache)
                    .plugin(:retries)
    end
  end
end
