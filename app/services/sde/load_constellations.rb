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
  end
end
