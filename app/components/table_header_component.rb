# frozen_string_literal: true

class TableHeaderComponent < ApplicationComponent
  attr_reader :padding

  def initialize(width: nil, classes: nil, padding: 'px-6 py-3')
    @width = width
    @classes = classes
    @padding = padding
  end

  def width_class_name
    "w-#{@width}"
  end

  def classes
    @classes || "#{padding} text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
  end
end
