# frozen_string_literal: true

class ActionButtonComponent < ApplicationComponent
  attr_reader :color, :href, :margin

  def initialize(href:, color: 'indigo', margin: nil)
    @color = color
    @href = href
    @margin = margin
  end

  def call
    render(LinkButtonComponent.new(href: @href, size: :md, color: @color, margin:).with_content(content))
  end
end
