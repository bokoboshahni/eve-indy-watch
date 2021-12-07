require 'benchmark'

namespace :market_orders do
  task jita: :environment do
    base_url = 'https://esi.evetech.net/latest/markets/10000002/orders'

    Benchmark.bm do |benchmark|
      benchmark.report("Typhoeus") do
        hydra = Typhoeus::Hydra.new
        requests = []
        request = Typhoeus::Request.new(base_url)
        request.on_complete do |response|
          pages = response.headers['X-Pages'].to_i
          (2..pages).each do |n|
            page_request = Typhoeus::Request.new(base_url, params: { page: n })
            requests << page_request
            hydra.queue(page_request)
          end
        end
        requests << request
        hydra.queue(request)
        hydra.run

        responses = requests.map { |request| request.response.body }
      end
    end
  end
end
