# frozen_string_literal: true

module StyleGuide
  class ColorStories < ApplicationStories
    story :light do
      constructor(dark_mode: false)
    end

    story :dark do
      constructor(dark_mode: true)
    end
  end
end
