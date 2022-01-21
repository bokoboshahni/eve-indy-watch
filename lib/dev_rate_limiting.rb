# frozen_string_literal: true

require 'fileutils'

module DevRateLimiting
  class << self
    FILE = 'tmp/rate-limiting-dev.txt'

    def enable_by_file
      FileUtils.mkdir_p('tmp')

      if File.exist?(FILE)
        delete_rate_limiting_file
        Rails.logger.debug 'Development mode is no longer being rate limited.'
      else
        create_rate_limiting_file
        Rails.logger.debug 'Development mode is now being rate limited.'
      end

      FileUtils.touch 'tmp/restart.txt'
    end

    def enable_by_argument(rate_limiting)
      FileUtils.mkdir_p('tmp')

      if rate_limiting
        create_rate_limiting_file
      elsif rate_limiting == false && File.exist?(FILE)
        delete_rate_limiting_file
      end
    end

    private

    def create_rate_limiting_file
      FileUtils.touch FILE
    end

    def delete_rate_limiting_file
      File.delete FILE
    end
  end
end
