# frozen_string_literal: true

namespace :bootstrap do
  task markets: :environment do
    config = Rails.application.config.x.app

    admin_user = Character.find(config.admin_character_ids.first).user
    abort('No admin user found. Log in to http://localhost:3000 with a user specified in ADMIN_CHARACTER_IDS') unless admin_user

    admin_auth = admin_user.esi_authorizations.first

    unless admin_auth
      abort(
        "No ESI authorization for #{admin_user.name} found. " \
        'Go to http://localhost:3000/settings/authorizations and create an authorization'
      )
    end

    alliance_id = config.main_alliance_id
    alliance = Alliance.find(alliance_id)

    unless ENV['MAIN_ALLIANCE_MARKET_STRUCTURE_ID']
      abort(
        'No alliance structure ID found. Specify alliance market structure ' \
        'ID in .env with MAIN_ALLIANCE_MARKET_STRUCTURE_ID'
      )
    end
    alliance_structure_id = ENV['MAIN_ALLIANCE_MARKET_STRUCTURE_ID'].to_i

    Market.transaction do
      jita = Market.create!(
        name: 'Jita',
        trade_hub: true,
        active: true,
        source_location: Location.find_by!(name: 'The Forge'),
        type_history_region: Region.find_by!(name: 'The Forge')
      )

      jita.stations << Station.find_by!(name: 'Jita IV - Moon 4 - Caldari Navy Assembly Plant')

      structure = Structure::SyncFromESI.call(alliance_structure_id, admin_auth)

      market = Market.create!(
        name: structure.solar_system_name,
        owner: alliance,
        private: true,
        source_location: Location.find_by!(name: structure.region_name),
        type_history_region: structure.region
      )
      market.structures << structure
      market.update(active: true)

      alliance.update!(appraisal_market: jita, main_market: market)
      alliance.alliance_locations.create!(location: Location.find(structure.id), default: true)
    end

    Market::IngestAllWorker.perform_async
  end
end
