# frozen_string_literal: true

Pry.config.prompt = Pry::Prompt[:rails]

markets_redis = Kredis.redis(config: :markets)
orders_redis = Kredis.redis(config: :orders)

forge_region = Region.find_by(name: 'The Forge')

jita_market = Market.find_by(name: 'Jita')
jita_station = jita_market.stations.first
