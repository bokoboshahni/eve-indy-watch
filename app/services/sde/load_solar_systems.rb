# frozen_string_literal: true

module SDE
  class LoadSolarSystems < YAMLLoader
    protected

    self.record_class = SolarSystem

    def load_records
      Dir["#{source_path}/**/solarsystem.staticdata"].each do |path|
        record(yaml(path), :solar_system_id, %w[name security], extra: { constellation_id: constellation_id(path) })
      end
    end

    private

    def constellation_id(solar_system_path)
      @constellation_ids ||= {}

      constellation_path = File.expand_path('../../constellation.staticdata', solar_system_path)
      return @constellation_ids[constellation_path] if @constellation_ids.key?(constellation_path)

      @constellation_ids[constellation_path] = yaml(constellation_path)['constellation_id']
    end
  end
end
