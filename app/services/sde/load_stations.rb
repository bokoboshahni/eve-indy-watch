# frozen_string_literal: true

module SDE
  class LoadStations < YAMLLoader
    protected

    self.record_class = Station

    def load_records
      Dir["#{source_path}/**/solarsystem.staticdata"].each do |path|
        solar_system = yaml(path)
        stations = solar_system['planets'].values.each_with_object({}) do |planet, h|
          h.merge!(planet.fetch('npc_stations', {}))

          planet.fetch('moons', {}).each_value { |moon| h.merge!(moon.fetch('npcStations', {})) }
        end

        stations.each do |(id, station)|
          record(
            station,
            id,
            %w[name owner_id type_id],
            extra: { solar_system_id: solar_system['solar_system_id'] }
          )
        end
      end
    end
  end
end
