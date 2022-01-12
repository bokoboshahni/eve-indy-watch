# frozen_string_literal: true

class Appraisal < ApplicationRecord
  class ParseItems < ApplicationService
    def initialize(original)
      super

      @original = original
    end

    def call
      lines = prepare_lines
    end

    private

    attr_reader :original

    def prepare_lines
      raw.strip.encode(universal_newline: true).split("\n").map(&:strip)
    end
  end
end
