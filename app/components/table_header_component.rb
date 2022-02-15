# frozen_string_literal: true

class TableHeaderComponent < ApplicationComponent
  attr_reader :padding, :colspan, :width, :align, :border, :rounding

  def initialize(width: nil, classes: nil, padding: 'px-6 py-3', colspan: nil, align: 'text-left', rounding: '') # rubocop:disable Metrics/ParameterLists
    @width = width
    @classes = classes
    @padding = padding
    @rounding = rounding
    @colspan = colspan
    @align = align
  end

  def classes
    @classes || "#{rounding} #{padding} #{width} #{align} text-xs font-medium uppercase tracking-wider"
  end
end
