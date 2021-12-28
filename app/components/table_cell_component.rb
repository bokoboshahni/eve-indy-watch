# frozen_string_literal: true

class TableCellComponent < ApplicationComponent
  attr_reader :padding, :colspan

  def initialize(classes: nil, bg_color: nil, padding: 'px-6 py-4', colspan: 1)
    @classes = classes
    @bg_color = bg_color
    @padding = padding
    @colspan = colspan
  end

  def classes
    @classes || "#{padding} text-xs"
  end
end
