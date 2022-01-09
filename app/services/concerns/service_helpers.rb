# frozen_string_literal: true

module ServiceHelpers
  extend ActiveSupport::Concern

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  include ESIHelpers

  protected

  delegate :debug, :error, :info, :measure_info, :trace, :warn, to: :logger

  def cmd
    @cmd ||= TTY::Command.new(output: logger)
  end

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
    @logger ||= Rails.logger
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

  def history_bucket_client
    @history_bucket_client ||= Aws::S3::Client.new(
      access_key_id: app_config.history_bucket_access_key_id,
      secret_access_key: app_config.history_bucket_secret_access_key,
      endpoint: app_config.history_bucket_endpoint,
      region: app_config.history_bucket_region
    )
  end

  def history_bucket_resource
    @history_bucket_resource ||= Aws::S3::Resource.new(client: history_bucket_client)
  end

  def history_bucket
    @history_bucket ||= history_bucket_resource.bucket(app_config.history_bucket_name)
  end

  def markets_reader
    Kredis.redis(config: :markets_reader)
  end

  def markets_writer
    Kredis.redis(config: :markets_writer)
  end

  def orders_reader
    Kredis.redis(config: :orders_reader)
  end

  def orders_writer
    Kredis.redis(config: :orders_writer)
  end

  def locations_reader
    Kredis.redis(config: :locations_reader)
  end

  def locations_writer
    Kredis.redis(config: :locations_writer)
  end
end
