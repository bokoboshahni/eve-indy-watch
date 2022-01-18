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

    def after_import
      locations = Region.pluck(:id, :name).each_with_object([]) do |(locatable_id, name), a|
        a << { locatable_id: locatable_id, locatable_type: 'Region', name: name }
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
