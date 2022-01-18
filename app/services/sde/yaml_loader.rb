# frozen_string_literal: true

module SDE
  class YAMLLoader < ApplicationService
    def initialize(source_path:, names: nil)
      super

      @source_path = source_path
      @names = names
      @records = []
    end

    def call
      load_records
      import_records
      after_import
    end

    protected

    PROGRESS_FORMAT = '[:bar] :current/:total :percent ET::elapsed ETA::eta :rate/s'

    class_attribute :record_class, :conflict_target

    self.conflict_target = %i[id]

    attr_reader :source_path, :names, :records, :total

    def import_records
      results = record_class.import(records, track_validation_failures: true,
                                             on_duplicate_key_update: { conflict_target: conflict_target, columns: :all })
      table = TTY::Table.new(header: %w[Table Processed Inserts Failures Total]) do |t|
        t << [record_class.name, records.count, results.num_inserts, results.failed_instances.count, record_class.count]
      end

      after_import

      say(table.render(:unicode))

      results.failed_instances.each { |i| say i.last.errors.full_messages } if results.failed_instances.any?
    end

    def after_import; end

    def yaml(path)
      data = YAML.load_file(path)
      if data.is_a?(Array)
        data.map { |item| item.deep_transform_keys { |k| k.is_a?(String) ? k.underscore : k } }
      else
        data.deep_transform_keys { |k| k.is_a?(String) ? k.underscore : k }
      end
    end

    def record(data, id, select, optional: [], rename: {}, extra: {}) # rubocop:disable Metrics/ParameterLists
      debug("Loading record: #{data}")
      rec = data.slice(*select).transform_keys { |k| rename.fetch(k, k) }

      rec['id'] = id.is_a?(Integer) ? id : data[id.to_s]
      rec['description'] = find_description(data) if select.include?('description')
      rec['name'] = find_name(data, rec['id']) if select.include?('name')

      yield rec if block_given?

      rec.merge!(extra.stringify_keys)
      optional.each { |f| rec[f] = nil unless rec.key?(f) }

      records << rec

      debug("Loaded record: #{rec}")
    end

    def find_description(record)
      return record.dig('description_id', 'en') if record.key?('description_id')

      ''
    end

    def find_name(record, id)
      name = record.dig('name', 'en')
      return name if name.present?

      name =
        case record['name_id']
        when Integer
          names[id]
        when Hash
          record['name_id']['en']
        end
      return name if name.present?

      names.fetch(id, '')
    end
  end
end
