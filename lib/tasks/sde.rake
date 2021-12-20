# frozen_string_literal: true

namespace :sde do # rubocop:disable Metrics/BlockLength
  desc 'Downloads the latest EVE static data export'
  task download: :environment do
    SDE::DownloadSDE.call(Rails.root.join('tmp'))
  end

  desc 'Loads the EVE static data export into the database'
  task load: %w[sde:load:corporations sde:load:items sde:load:map sde:load:inventory_flags sde:load:industry]

  namespace :load do # rubocop:disable Metrics/BlockLength
    task map: %i[regions constellations solar_systems stations]

    task items: %i[categories groups market_groups types]

    task industry: %i[blueprints]

    task setup: :environment do
      @sde_path = Rails.root.join('tmp/sde')
      @names = SDE::LoadNames.call(source_path: @sde_path.join('bsd/invNames.yaml'))
    end

    task blueprints: :setup do
      SDE::LoadBlueprints.call(source_path: @sde_path.join('fsd/blueprints.yaml'))
    end

    task categories: :setup do
      SDE::LoadCategories.call(source_path: @sde_path.join('fsd/categoryIDs.yaml'))
    end

    task constellations: :setup do
      SDE::LoadConstellations.call(source_path: @sde_path.join('fsd/universe'), names: @names)
    end

    task corporations: :setup do
      SDE::LoadCorporations.call(source_path: @sde_path.join('fsd/npcCorporations.yaml'), names: @names)
    end

    task groups: :setup do
      SDE::LoadGroups.call(source_path: @sde_path.join('fsd/groupIDs.yaml'), names: @names)
    end

    task inventory_flags: :setup do
      SDE::LoadInventoryFlags.call(source_path: @sde_path.join('bsd/invFlags.yaml'))
    end

    task market_groups: :setup do
      SDE::LoadMarketGroups.call(source_path: @sde_path.join('fsd/marketGroups.yaml'))
    end

    task regions: :setup do
      SDE::LoadRegions.call(source_path: @sde_path.join('fsd/universe'), names: @names)
    end

    task solar_systems: :setup do
      SDE::LoadSolarSystems.call(source_path: @sde_path.join('fsd/universe'), names: @names)
    end

    task stations: :setup do
      SDE::LoadStations.call(source_path: @sde_path.join('fsd/universe/eve'), names: @names)
    end

    task types: :setup do
      SDE::LoadTypes.call(source_path: @sde_path.join('fsd/typeIDs.yaml'), names: @names)
    end
  end
end
