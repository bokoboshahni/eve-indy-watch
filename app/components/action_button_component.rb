# frozen_string_literal: true

class ActionButtonComponent < ApplicationComponent
  attr_reader :color, :href

  def initialize(color: 'indigo', href:)
    @color = color
    @href = href
  end

  def call
    render(LinkButtonComponent.new(href: @href, size: :md, color: @color).with_content(content))
  end
end
