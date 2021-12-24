# frozen_string_literal: true

class SectionHeadingComponent < ApplicationComponent
  attr_reader :title, :width

  renders_one :description
  renders_one :sorter

  renders_many :actions
  renders_many :inline_tabs

  def initialize(title:, width: '7xl')
    @title = title
    @width = width
  end

  def width_class_name
    "max-w-#{width}"
  end
end
