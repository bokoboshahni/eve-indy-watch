# frozen_string_literal: true

class PageHeadingComponent < ApplicationComponent
  renders_many :actions

  def initialize(title:, width: '7xl')
    @title = title
    @width = width
  end

  def width_class_name
    "max-w-#{@width}"
  end
end
