# frozen_string_literal: true

class TableRowComponent < ApplicationComponent
  attr_reader :classes

  renders_many :cells, TableCellComponent
  renders_many :headers, TableHeaderComponent

  def initialize(classes: nil)
    @classes = classes
  end
end
