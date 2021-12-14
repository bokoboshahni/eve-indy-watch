# frozen_string_literal: true

class TableHeaderComponent < ApplicationComponent
  def initialize(width: nil)
    @width = width
  end

  def width_class_name
    "w-#{@width}"
  end
end
