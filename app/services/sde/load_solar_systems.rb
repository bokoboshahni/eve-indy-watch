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

    def after_import
      locations = SolarSystem.pluck(:id, :name).each_with_object([]) do |(locatable_id, name), a|
        a << { locatable_id:, locatable_type: 'SolarSystem', name: }
      end

      Location.import!(
        locations,
        on_duplicate_key_update: {
          conflict_target: %i[locatable_id locatable_type],
          columns: :all
        }
      )
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
