# frozen_string_literal: true

class TableCellComponent < ApplicationComponent
  def initialize(classes: nil, bg_color: nil)
    @classes = classes
    @bg_color = bg_color
  end

  def classes
    @classes || 'px-6 py-4 text-xs'
  end
end
