# frozen_string_literal: true

namespace :dev do
  task rate_limiting: :environment do
    require_relative '../dev_rate_limiting'
    DevRateLimiting.enable_by_file
  end
end
