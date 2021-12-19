# frozen_string_literal: true

class TableHeaderComponent < ApplicationComponent
  def initialize(width: nil, classes: nil)
    @width = width
    @classes = classes
  end

  def width_class_name
    "w-#{@width}"
  end

  def classes
    @classes || 'px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider'
  end
end
