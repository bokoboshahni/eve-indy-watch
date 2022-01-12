# frozen_string_literal: true

module Statistics
  class ApplicationRecord < ::ApplicationRecord
    self.abstract_class = true

    connects_to database: { reading: :statistics, writing: :statistics }
  end
end
