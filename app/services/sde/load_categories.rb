# frozen_string_literal: true

module SDE
  class LoadCategories < YAMLLoader
    protected

    self.record_class = Category

    def load_records
      yaml(source_path).each { |(id, category)| record(category, id, %w[name published]) }
    end
  end
end
