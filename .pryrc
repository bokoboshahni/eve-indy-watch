# frozen_string_literal: true

Pry.config.prompt = Pry::Prompt[:rails]

markets_reader = Kredis.redis(config: :markets_reader)
orders_reader = Kredis.redis(config: :orders_reader)

forge_region = Region.find_by(name: 'The Forge')

jita_market = Market.find_by(name: 'Jita')
jita_station = jita_market.stations.first
