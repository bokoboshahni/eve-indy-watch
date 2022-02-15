# frozen_string_literal: true

module StyleGuide
  class Color < ApplicationComponent
    def initialize(dark_mode:)
      @dark_mode = dark_mode
    end

    private

    attr_reader :dark_mode
  end
end
