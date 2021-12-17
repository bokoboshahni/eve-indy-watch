class StatisticsRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :statistics }
end
