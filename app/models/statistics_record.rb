# frozen_string_literal: true

class StatisticsRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :statistics, reading: :statistics }
end
