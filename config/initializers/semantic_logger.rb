# frozen_string_literal: true

if ENV['RAILS_LOG_TO_GELF'].present?
  require 'gelf'

  SemanticLogger.add_appender(
    appender: :graylog,
    url: "udp://#{ENV['GELF_UDP_ADDRESS']}:#{ENV.fetch('GELF_UDP_PORT', 12_201)}"
  )
end
