unless Rails.env == "test"
  require 'prometheus_exporter/middleware'
  Rails.application.middleware.unshift PrometheusExporter::Middleware

  require 'prometheus_exporter/instrumentation'
  PrometheusExporter::Instrumentation::Process.start(type: "master")
end
