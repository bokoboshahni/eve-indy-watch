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

  def hydra
    @hydra ||= Typhoeus::Hydra.new
  end

  def default_headers
    { 'User-Agent': esi_config.user_agent }
  end

  def authenticated_with(authorization)
    esi_authorize!(authorization)
    access_token = authorization.access_token
    yield access_token
  end

  def httpx
    @httpx ||= HTTPX.with_headers(httpx_default_headers)
                      .plugin(:authentication)
                      .plugin(:persistent)
                      .plugin(:response_cache)
                      .plugin(:retries)
  end

  def httpx_authenticated(authorization)
    esi_authorize!(authorization)
    access_token = authorization.access_token
    httpx.authentication("Bearer #{access_token}")
  end
end
