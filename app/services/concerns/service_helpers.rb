# frozen_string_literal: true

module ServiceHelpers
  extend ActiveSupport::Concern

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ESIHelpers

  protected

  delegate :debug, :error, :info, :warn, to: :logger

  def cache
    Rails.cache
  end

  def config
    Rails.application.config
  end

  def app_config
    config.x.app
  end

  def esi_config
    config.x.esi
  end

  def logger
    Rails.logger
  end

  def say(msg)
    $stdout.puts(msg)
  end
end
