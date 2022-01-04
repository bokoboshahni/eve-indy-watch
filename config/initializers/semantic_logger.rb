if ENV['RAILS_LOG_TO_GELF'].present?
  SemanticLogger.add_appender(
    appender: :graylog,
    url:      "udp://#{ENV['GELF_UDP_ADDRESS']}:#{ENV.fetch('GELF_UDP_PORT', 12201)}",
  )
end
