# frozen_string_literal: true

class TypeIconComponent < ApplicationComponent
  attr_reader :type, :classes

  def initialize(type:, classes: nil)
    @type = type
    @classes = classes
  end

  def call
    image_tag icon_url, class: classes
  end

  def icon_url
    return asset_pack_path('media/images/blueprint.png') if type.blueprint?

    return asset_pack_path('media/images/empire-crate.png') if type.skin?

    type.icon_url
  end
end
