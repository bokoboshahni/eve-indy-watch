# frozen_string_literal: true

class TableCellComponent < ApplicationComponent
  def initialize(classes: nil)
    @classes = classes
  end

  def classes
    @classes || 'px-6 py-4 text-xs'
  end
end
