# frozen_string_literal: true

class CardComponent < ApplicationComponent
  attr_reader :title, :header_class_names, :body_class_names, :footer_bg, :footer_padding, :ball, :ball_color

  renders_one :header
  renders_one :body
  renders_one :description
  renders_one :footer

  renders_many :actions

  def initialize( # rubocop:disable Metrics/ParameterLists
    title: nil,
    header_class_names: 'px-4 py-5 sm:px-6',
    body_class_names: 'px-4 py-5 sm:px-6',
    footer_padding: 'px-4 py-5 sm:px-6',
    footer_bg: 'bg-white dark:bg-zinc-800',
    ball: false,
    ball_color: nil
  )
    @title = title
    @body_class_names = body_class_names
    @footer_padding = footer_padding
    @footer_bg = footer_bg
    @header_class_names = header_class_names
    @ball = ball
    @ball_color = ball_color
  end

  def footer_class_names
    "#{footer_padding} #{footer_bg} rounded-bl-lg rounded-br-lg"
  end
end
