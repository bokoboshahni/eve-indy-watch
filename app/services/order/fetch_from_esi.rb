class Order < StatisticsRecord
  class FetchFromESI < ApplicationService
    def initialize(location)
      super

      @location = location
    end

    def call
      fetch_page_count

      if File.exists?(orders_dir)
        warn("Orders have already been fetched for #{location.log_name} at #{time.to_s(:db)}")
        return
      end

      fetch_pages

      time
    rescue
      FileUtils.rm_rf(orders_dir) if orders_dir && File.exists?(orders_dir)
      raise
    end

    private

    KEYS = {
      'duration'        => 'd',
      'is_buy_order'    => 'b',
      'issued'          => 'i',
      'location_id'     => 'l',
      'min_volume'      => 'vm',
      'order_id'        => 'o',
      'price'           => 'p',
      'range'           => 'r',
      'system_id'       => 's',
      'type_id'         => 't',
      'volume_remain'   => 'v',
      'volume_total'    => 'vt'
    }

    attr_reader :location, :page_count, :time, :batch, :expires, :etag, :orders_dir

    delegate :id, to: :location, prefix: true

    def fetch_page_count
      Retriable.retriable tries: 10 do
        req =  Typhoeus::Request.new(location_url, method: :head, headers: headers)
        req.on_headers do |response|
          raise "Request for HEAD #{location_url} failed" unless response.code == 200
        end

        resp = req.run

        headers = resp.headers
        @time = headers['last-modified'].to_datetime
        @expires = headers['expires']
        @etag = headers['etag']
        @page_count = headers['X-Pages'].to_i
        @orders_dir = Rails.root.join("tmp/orders/#{location_id}/#{time.to_s(:number)}")
      end
    end

    def fetch_pages
      FileUtils.mkdir_p(orders_dir)

      pages = []
      pending_pages = page_count.times.to_a.map { |n| n + 1 }
      orders = []

      while pending_pages.any? do
        pending_pages.each do |page|
          req = Typhoeus::Request.new(location_url, params: { page: page }, headers: headers.merge(etag: etag))
          req.on_complete do |res|
            next if res.code != 200

            next if res.body =~ /error/

            next if res.body =~ /\A50\d/

            next if res.body.strip.empty?

            orders.push(*Oj.load(res.body).map! { |o| o.transform_keys! { |k| KEYS.fetch(k) }})
            pending_pages.delete(page)
          end
          hydra.queue(req)
        end
        hydra.run
      end

      orders.uniq { |o| o['o'] }.each_slice(1000).with_index do |(*slice), i|
        orders_file = File.join(orders_dir, "#{i + 1}.json")
        File.write(orders_file, Oj.dump(slice))
      end

      debug("Wrote #{orders.count} order(s) to #{orders_dir}")
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
        "https://esi.evetech.net/latest/markets/#{location_id}/orders"
      when Structure
        "https://esi.evetech.net/latest/markets/structures/#{location_id}"
      end
    end
  end
end
