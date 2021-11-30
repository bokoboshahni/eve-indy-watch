# frozen_string_literal: true

module SDE
  class LoadRegions < YAMLLoader
    protected

    self.record_class = Region

    def load_records
      Dir["#{source_path}/**/region.staticdata"].each do |path|
        record(yaml(path), :region_id, %w[name])
      end
    end
  end
end
