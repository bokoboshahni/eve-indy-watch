# frozen_string_literal: true

class TableRowComponent < ApplicationComponent
  renders_many :cells, TableCellComponent
end
