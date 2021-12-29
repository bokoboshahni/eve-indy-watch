# frozen_string_literal: true

class DataTableSorterComponent < ApplicationComponent
  attr_reader :name, :filter

  def initialize(name:, filter:)
    @name = name
    @filter = filter
  end
end
