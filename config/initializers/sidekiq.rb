# frozen_string_literal: true

require 'prometheus_exporter/instrumentation'

require 'sidekiq/throttled'
Sidekiq::Throttled.setup!

SidekiqUniqueJobs.config.lock_info = true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('SIDEKIQ_REDIS_URL', 'redis://localhost:6379/1'), driver: :hiredis }

  config.error_handlers.pop
  config.error_handlers << lambda do |ex, ctx|
    Sidekiq.logger.error("#{ex.class.name}: #{ex.message}", ctx, ex)
  end

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add PrometheusExporter::Instrumentation::Sidekiq unless ENV['DISABLE_PROMETHEUS'].present?
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  config.on :startup do
    unless ENV['DISABLE_PROMETHEUS'].present?
      PrometheusExporter::Instrumentation::ActiveRecord.start(
        custom_labels: { type: "sidekiq" },
        config_labels: [:database, :host]
      )
      PrometheusExporter::Instrumentation::Process.start type: 'sidekiq'
      PrometheusExporter::Instrumentation::SidekiqProcess.start
      PrometheusExporter::Instrumentation::SidekiqQueue.start
      PrometheusExporter::Instrumentation::SidekiqStats.start
    end
  end

  config.death_handlers << PrometheusExporter::Instrumentation::Sidekiq.death_handler unless ENV['DISABLE_PROMETHEUS'].present?

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

sidekiq_logger = SemanticLogger[Sidekiq]
sidekiq_logger.filter = lambda do |log|
  log.message !~ /\A(start|done|fail)\z/
end

Sidekiq.logger = sidekiq_logger

require 'sidekiq/web'
require 'sidekiq-scheduler/web'
require 'sidekiq/throttled/web'
require 'sidekiq_unique_jobs/web'
