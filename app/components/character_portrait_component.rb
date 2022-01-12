# frozen_string_literal: true

class CharacterPortraitComponent < ApplicationComponent
  attr_reader :character, :classes

  def initialize(character:, classes: nil)
    @character = character
    @classes = classes
  end

  def call
    image_tag icon_url, class: classes
  end

  def icon_url
    return character.portrait_url_256 if character.portrait_url_256

    asset_pack_path('media/images/character-default.png')
  end
end
