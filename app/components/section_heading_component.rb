# frozen_string_literal: true

class SectionHeadingComponent < ApplicationComponent
  attr_reader :title, :width

  renders_one :description

  renders_many :actions, ActionButtonComponent

  def initialize(title:, width: '7xl')
    @title = title
    @width = width
  end

  def width_class_name
    "max-w-#{width}"
  end
end
