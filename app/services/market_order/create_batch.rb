class MarketOrder < ApplicationRecord
  class CreateBatch < ApplicationService
    def initialize(location)
      super

      @location = location
    end

    def call
      unless location.esi_market_orders_expired?
        debug("Market orders are not expired for #{location.log_name}")
        return
      end

      fetch_page_count_and_time
      return if Batch.exists?(location_id: location.id, time: time)

      Batch.transaction do
        @batch = Batch.create!(location: location, time: time)
        pages = fetch_pages(@batch)
        BatchPage.import(pages, validate: false)
        batch.update!(fetched_at: Time.zone.now)
        location.update!(esi_market_orders_expires_at: expires, esi_market_orders_last_modified_at: time)
        batch
      end
    end

    private

    attr_reader :location, :page_count, :time, :batch, :expires

    def fetch_page_count_and_time
      Retriable.retriable tries: 10 do
        req =  Typhoeus::Request.new(location_url, method: :head, headers: headers)
        req.on_headers do |response|
          raise "Request for HEAD #{location_url} failed" unless response.code == 200
        end

        resp = req.run

        headers = resp.headers
        @time = headers['last-modified']
        @expires = headers['expires']
        @page_count = headers['X-Pages'].to_i
      end
    end

    def fetch_pages(batch)
      pages = []
      pending_pages = page_count.times.to_a.map { |n| n + 1 }

      while pending_pages.any? do
        pending_pages.each do |page|
          req = Typhoeus::Request.new(location_url, params: { page: page }, headers: headers)
          req.on_complete do |res|
            next if res.code != 200

            next if res.body =~ /error/

            next if res.body =~ /\A50\d/

            next if res.body.strip.empty?

            pages << { batch_id: batch.id, orders: res.body, page: page }
            pending_pages.delete(page)
          end
          hydra.queue(req)
        end
        hydra.run
      end

      pages
    end

    def headers
      headers = default_headers

      if location.is_a?(Structure)
        unless location.esi_authorized?
          raise Error, "#{location.class.name} #{location.log_name} has no ESI authorization"
        end

        esi_authorize!(location.esi_authorization)
        access_token = location.esi_authorization.access_token
        headers = headers.merge('Authorization': "Bearer #{access_token}") if location.is_a?(Structure)
      end

      headers
    end

    def location_url
      case location
      when Region
        "https://esi.evetech.net/latest/markets/#{location.id}/orders"
      when Structure
        "https://esi.evetech.net/latest/markets/structures/#{location.id}"
      end
    end
  end
end
