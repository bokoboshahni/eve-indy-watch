# frozen_string_literal: true

unless Rails.env.test? || ENV['DISABLE_PROMETHEUS'].present?
  require 'prometheus_exporter/middleware'
  Rails.application.middleware.unshift PrometheusExporter::Middleware

  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::Process.start(type: 'master')
end
