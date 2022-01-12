# frozen_string_literal: true

class CorporationIconComponent < ApplicationComponent
  attr_reader :corporation, :classes

  def initialize(corporation:, classes: nil)
    @corporation = corporation
    @classes = classes
  end

  def call
    image_tag icon_url, class: classes
  end

  def icon_url
    return corporation.icon_url_256 if corporation.icon_url_256

    asset_pack_path('media/images/corporation-default.png')
  end
end
