# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

require 'view_component/test_helpers'
require 'capybara/rspec'

require 'pundit/rspec'

require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.ignore_hosts '127.0.0.1', 'localhost', 'chromedriver.storage.googleapis.com'
  config.cassette_library_dir = Rails.root.join('spec/cassettes')
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

RSpec.configure do |config|
  # Ensure that if we are running js tests, we are using latest webpack assets
  # This will use the defaults of :js and :server_rendering meta tags
  ReactOnRails::TestHelper.configure_rspec_to_compile_assets(config)

  config.include FactoryBot::Syntax::Methods

  config.include ViewComponent::TestHelpers, type: :component
  config.include Capybara::RSpecMatchers, type: :component

  config.include RequestHelpers, type: :request

  config.include SystemHelpers, type: :system

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!

  config.before do
    Kredis.redis(config: :shared).flushall
    Kredis.redis(config: :markets_writer).flushall
    Kredis.redis(config: :locations_writer).flushall
    Kredis.redis(config: :orders_writer).flushall
  end
end
