# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require "active_storage/engine"
require 'action_controller/railtie'
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require 'action_view/railtie'
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EVEIndyWatch
  class Application < Rails::Application
    DEFAULT_ESI_OAUTH_URL = 'https://login.eveonline.com'

    DEFAULT_ESI_SCOPES = %w[
      esi-universe.read_structures.v1
      esi-markets.structure_markets.v1
      esi-contracts.read_corporation_contracts.v1
    ].freeze

    DEFAULT_ESI_USER_AGENT = 'EVE Indy Watch/1.0; (+https://github.com/bokoboshahni/eve-indy-watch)'

    DEFAULT_SITE_NAME = 'EVE Indy Watch'

    config.load_defaults 6.1

    config.active_job.queue_adapter = :sidekiq

    config.active_record.schema_format = :sql

    config.generators.system_tests = nil
    config.generators.stylesheets = false
    config.generators.javascripts = false

    if ENV['RAILS_LOG_TO_GELF'].present?
      config.lograge.formatter = Lograge::Formatters::Graylog2.new
      config.logger = GELF::Logger.new(ENV['GELF_UDP_ADDRESS'], ENV.fetch('GELF_UDP_PORT', 12201), ENV.fetch('GELF_MAX_SIZE', 'WAN'))
    end

    config.lograge.custom_options = lambda do |event|
      {
        application: ENV['SITE_NAME'].dasherize,
        host: event.payload[:host],
        rails_env: Rails.env,

        process_id: Process.pid,
        request_id: event.payload[:headers]['action_dispatch.request_id'],
        request_time: Time.now,

        remote_ip: event.payload[:remote_ip],
        ip: event.payload[:ip],
        x_forwarded_for: event.payload[:x_forwarded_for],

        params: event.payload[:params].except(*config.filter_parameters).to_json,

        exception: event.payload[:exception]&.first,
        exception_message: "#{event.payload[:exception]&.last}",
        exception_backtrace: event.payload[:exception_object]&.backtrace&.join(",")
      }.compact
    end

    config.x.esi.client_id = ENV['ESI_CLIENT_ID']
    config.x.esi.client_secret = ENV['ESI_CLIENT_SECRET']
    config.x.esi.oauth_url = ENV.fetch('ESI_OAUTH_URL', DEFAULT_ESI_OAUTH_URL)
    config.x.esi.redirect_uri = ENV['ESI_REDIRECT_URI']
    config.x.esi.scopes = DEFAULT_ESI_SCOPES
    config.x.esi.user_agent = ENV.fetch('ESI_USER_AGENT', DEFAULT_ESI_USER_AGENT)

    config.x.app.admin_character_ids = ENV.fetch('ADMIN_CHARACTER_IDS', '').strip.split(',').map(&:to_i)
    config.x.app.allowed_alliance_ids = ENV.fetch('ALLOWED_ALLIANCE_IDS', '').strip.split(',').map(&:to_i)
    config.x.app.allowed_corporation_ids = ENV.fetch('ALLOWED_CORPORATION_IDS', '').strip.split(',').map(&:to_i)
    config.x.app.main_alliance_id = ENV.fetch('MAIN_ALLIANCE_ID').to_i
    config.x.app.site_name = ENV.fetch('SITE_NAME', DEFAULT_SITE_NAME)
  end
end
