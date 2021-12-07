# frozen_string_literal: true

class MarketOrderSnapshot < ApplicationRecord
  class FetchLocationFromESI < ApplicationService
    include ESIHelpers

    def initialize(location)
      super

      @location = location
    end

    def call # rubocop:disable Metrics/AbcSize
      unless location.esi_market_orders_expired?
        debug("ESI response for market orders at #{location.name} (#{location.id}) is not expired: #{location.esi_market_orders_expires_at.iso8601}")
        return
      end

      Retriable.retriable(tries: 10) do
        if location.is_a?(Region)
          url = "https://esi.evetech.net/latest/markets/#{location.id}/orders"
          hydra = Typhoeus::Hydra.new
          requests = []
          pages = 0
          request = Typhoeus::Request.new(url)
          request.on_complete do |response|
            pages = response.headers['X-Pages'].to_i
            (2..pages).each do |n|
              page_request = Typhoeus::Request.new(url, params: { page: n })
              page_request.on_complete do |response|
                if response.body =~ /502 Bad Gateway/
                  hydra.queue(page_request)
                end
              end
              requests << page_request
              hydra.queue(page_request)
            end
          end
          requests << request
          hydra.queue(request)
          hydra.run

          expires = requests.first.response.headers['expires']
          last_modified = requests.first.response.headers['last-modified']

          responses = requests.reject { |request| request.response.body =~ /502 Bad Gateway/ }.map { |request| request.response.body }

          raise "Something is missing" if pages != responses.count

          [responses, last_modified, expires]
        elsif location.is_a?(Structure)
          raise Error.new("#{location.class.name} #{location.name} (#{location.id}) has no ESI authorization") unless location.esi_authorized?

          esi_authorize!(location.esi_authorization)
          auth = { Authorization: "Bearer #{location.esi_authorization.access_token}" }
          responses = esi.get_markets_structure_raw(structure_id: location.id, headers: auth)
          expires = responses.first.headers['expires']
          last_modified = responses.first.headers['last-modified']
          [responses.map(&:body), last_modified, expires]
        end
      end
    end

    private

    attr_reader :location
  end
end
