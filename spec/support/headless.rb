# frozen_string_literal: true

require 'webdrivers/chromedriver'

module IgnoreMissingStaticFiles
  IGNORE_MESSAGES = [
    %r{No route matches .*"/images/http:/packs-test/[^"]+"}i
  ].freeze

  def raise_server_error!
    super
  rescue StandardError => e
    raise e unless IGNORE_MESSAGES.any? { |ignore_message| e.message =~ ignore_message }
  end
end

Capybara::Session.class_eval do
  prepend IgnoreMissingStaticFiles
end

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new.tap do |opts|
    opts.add_argument('--headless')
    opts.add_argument('--disable-gpu') if Gem.win_platform?
    # Workaround https://bugs.chromium.org/p/chromedriver/issues/detail?id=2650&q=load&sort=-id&colspec=ID%20Status%20Pri%20Owner%20Summary
    opts.add_argument('--disable-site-isolation-trials')
    opts.add_argument('--disable-dev-shm-usage')
    opts.add_argument('--no-sandbox')
    opts.add_preference('download.default_directory', Capybara.save_path)
    opts.add_preference(:download, default_directory: Capybara.save_path)
  end

  Capybara::Selenium::Driver.new(app, **{ browser: :chrome, capabilities: browser_options })
end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium_chrome_headless
  end
end
