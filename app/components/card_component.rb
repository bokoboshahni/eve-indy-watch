# frozen_string_literal: true

class CardComponent < ApplicationComponent
  attr_reader :title

  attr_reader :body_class_names
  attr_reader :footer_bg, :footer_padding

  renders_one :header
  renders_one :body
  renders_one :description
  renders_one :footer

  renders_many :actions

  def initialize(title: nil, body_class_names: 'px-4 py-5 sm:px-6', footer_padding: 'px-4 py-5 sm:px-6', footer_bg: 'bg-white')
    @title = title
    @body_class_names = body_class_names
    @footer_padding = footer_padding
    @footer_bg = footer_bg
  end

  def header_class_names
    "px-4 py-5 sm:px-6"
  end

  def footer_class_names
    "#{footer_padding} #{footer_bg}"
  end
end
