# frozen_string_literal: true

class ActionButtonComponent < ApplicationComponent
  attr_reader :color, :href, :margin

  def initialize(color: 'indigo', href:, margin: nil)
    @color = color
    @href = href
    @margin = margin
  end

  def call
    render(LinkButtonComponent.new(href: @href, size: :md, color: @color, margin: margin).with_content(content))
  end
end
