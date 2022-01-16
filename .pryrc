# frozen_string_literal: true

Pry.config.prompt = Pry::Prompt[:rails]
Pry.config.pager = false

markets_reader = Kredis.redis(config: :markets_reader)
markets_writer = Kredis.redis(config: :markets_writer)
orders_reader = Kredis.redis(config: :orders_reader)
orders_writer = Kredis.redis(config: :orders_writer)
