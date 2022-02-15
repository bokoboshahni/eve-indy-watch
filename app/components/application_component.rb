# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  delegate :heroicon, :turbo_frame_tag, to: :helpers

  PRIMARY_COLOR_NAME_LIGHT = 'indigo'
  PRIMARY_COLOR_NAME_DARK = 'sky'

  NEUTRAL_COLOR_NAME_LIGHT = 'gray'
  NEUTRAL_COLOR_NAME_DARK = 'zinc'

  def primary_color_light(shade)
    "#{PRIMARY_COLOR_NAME_LIGHT}-#{shade}"
  end

  def primary_color_dark(shade)
    "#{PRIMARY_COLOR_NAME_DARK}-#{shade}"
  end

  def neutral_color_light(shade)
    "#{NEUTRAL_COLOR_NAME_LIGHT}-#{shade}"
  end

  def neutral_color_dark(shade)
    "#{NEUTRAL_COLOR_NAME_DARK}-#{shade}"
  end
end
