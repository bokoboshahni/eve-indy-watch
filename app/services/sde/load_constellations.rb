# frozen_string_literal: true

module SDE
  class LoadConstellations < YAMLLoader
    protected

    self.record_class = Constellation

    def load_records
      paths = Dir["#{source_path}/**/constellation.staticdata"]
      region_ids = {}
      paths.each do |path|
        constellation = yaml(path)
        region_path = File.expand_path('../../region.staticdata', path)
        region_id = region_ids[region_path] || (region_ids[region_path] = yaml(region_path)['region_id'])
        record(constellation, :constellation_id, %w[name], extra: { region_id: region_id })
      end
    end

    def after_import
      locations = Constellation.pluck(:id, :name).each_with_object([]) do |(locatable_id, name), a|
        a << { locatable_id: locatable_id, locatable_type: 'Constellation', name: name }
      end

      Location.import!(
        locations,
        on_duplicate_key_update: {
          conflict_target: %i[locatable_id locatable_type],
          columns: :all
        }
      )
    end
  end
end
