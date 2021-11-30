# frozen_string_literal: true

module SDE
  class LoadGroups < YAMLLoader
    protected

    self.record_class = Group

    def load_records
      yaml(source_path).each { |(id, group)| record(group, id, %w[category_id name published]) }
    end
  end
end
