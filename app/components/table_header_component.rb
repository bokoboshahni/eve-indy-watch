# frozen_string_literal: true

class TableHeaderComponent < ApplicationComponent
  attr_reader :padding, :colspan, :width, :align, :border

  def initialize(width: nil, classes: nil, padding: 'px-6 py-3', colspan: nil, align: 'text-left')
    @width = width
    @classes = classes
    @padding = padding
    @colspan = colspan
    @align = align
  end

  def classes
    @classes || "#{padding} #{width} #{align} text-xs font-medium text-gray-500 uppercase tracking-wider"
  end
end
