# frozen_string_literal: true

require 'prometheus_exporter/instrumentation'

require 'sidekiq/throttled'
Sidekiq::Throttled.setup!

SidekiqUniqueJobs.config.lock_info = true

if ENV['RAILS_LOG_TO_GELF'].present?
  Sidekiq.logger = GELF::Logger.new(ENV['GELF_UDP_ADDRESS'], ENV.fetch('GELF_UDP_PORT', 12201), ENV.fetch('GELF_MAX_SIZE', 'WAN'))
end

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL', 'redis://localhost:6379/1'), driver: :hiredis }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add PrometheusExporter::Instrumentation::Sidekiq
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  config.on :startup do
    PrometheusExporter::Instrumentation::ActiveRecord.start(
      custom_labels: { type: "sidekiq" },
      config_labels: [:database, :host]
    )
    PrometheusExporter::Instrumentation::Process.start type: 'sidekiq'
    PrometheusExporter::Instrumentation::SidekiqProcess.start
    PrometheusExporter::Instrumentation::SidekiqQueue.start
    PrometheusExporter::Instrumentation::SidekiqStats.start
  end

  config.death_handlers << PrometheusExporter::Instrumentation::Sidekiq.death_handler

  SidekiqUniqueJobs::Server.configure(config)

  at_exit do
    PrometheusExporter::Client.default.stop(wait_timeout_seconds: 10)
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL', 'redis://localhost:6379/1'), driver: :hiredis }

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require 'sidekiq/throttled/web'
require 'sidekiq_unique_jobs/web'
