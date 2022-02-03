# frozen_string_literal: true

Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore

Rack::MiniProfiler.config.skip_paths << /beta/
