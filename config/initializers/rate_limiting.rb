# frozen_string_literal: true

ENV.fetch('RATE_LIMITING_SAFELIST_IPS', '').strip.split(',').each do |ip|
  Rack::Attack.safelist_ip(ip)
end

ENV.fetch('RATE_LIMITING_BLOCKLIST_IPS', '').strip.split(',').each do |ip|
  Rack::Attack.blocklist_ip(ip)
end

Rack::Attack.throttled_response_retry_after_header = true

requests_by_ip_limit = ENV.fetch('RATE_LIMITING_REQUESTS_BY_IP_LIMIT', 5000).to_i
requests_by_ip_period = ENV.fetch('RATE_LIMITING_REQUESTS_BY_IP_LIMIT', 3600).to_i
Rack::Attack.throttle('Requests by IP', limit: requests_by_ip_limit, period: requests_by_ip_period, &:ip)
