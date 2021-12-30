# frozen_string_literal: true

class AllianceIconComponent < ApplicationComponent
  attr_reader :alliance, :classes

  def initialize(alliance:, classes: nil)
    @alliance = alliance
    @classes = classes
  end

  def call
    image_tag icon_url, class: classes
  end

  def icon_url
    return alliance.icon_url_128 if alliance.icon_url_128

    return asset_pack_path('media/images/alliance-default.png')
  end
end
