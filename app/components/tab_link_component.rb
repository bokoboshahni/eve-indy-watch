# frozen_string_literal: true

class TabLinkComponent < ApplicationComponent
  attr_reader :href, :turbo_frame, :class_name
  attr_accessor :current

  DEFAULT_CLASS_NAME =

    def initialize(href:, turbo_frame: nil, class_name: nil)
      @href = href
      @turbo_frame = turbo_frame
      @class_name = class_name
    end

  def call
    options = { class: class_name }
    options[:data] = { turbo_frame: } if turbo_frame
    link_to(href, options) { content }
  end
end
