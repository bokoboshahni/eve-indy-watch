# frozen_string_literal: true

class CharacterPortraitComponent < ApplicationComponent
  DEFAULT_PORTRAIT_PATH = 'static/character-default.png'

  attr_reader :character, :classes

  def initialize(character:, classes: nil)
    @character = character
    @classes = classes
  end

  def call
    return image_pack_tag(DEFAULT_PORTRAIT_PATH, class: classes) unless character.portrait_url_256

    image_tag character.portrait_url_256, class: classes
  end
end
