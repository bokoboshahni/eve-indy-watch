# frozen_string_literal: true

namespace :data do
  desc 'Creates the Jita market'
  task create_jita_market: :environment do
    Market.transaction do
      market = Market.create!(
        name: 'Jita',
        trade_hub: true,
        active: true,
        source_location: Location.find_by!(name: 'The Forge'),
        type_history_region: Region.find_by!(name: 'The Forge')
      )

      market.stations << Station.find_by!(name: 'Jita IV - Moon 4 - Caldari Navy Assembly Plant')
    end
  end
end
