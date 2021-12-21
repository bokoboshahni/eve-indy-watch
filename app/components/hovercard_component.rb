# frozen_string_literal: true

class HovercardComponent < ApplicationComponent
  attr_reader :class_name, :url

  def initialize(url:, class_name: nil)
    @url = url
    @class_name = class_name
  end

  def call
    content_tag :div, content, class: class_name, data: data
  end

  private

  def data
    {
      controller: 'hovercard',
      hovercard_url_value: url,
      action: 'mouseenter->hovercard#show mouseleave->hovercard#hide'
    }
  end
end
