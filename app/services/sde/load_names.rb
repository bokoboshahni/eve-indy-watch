# frozen_string_literal: true

module SDE
  class LoadNames < ApplicationService
    def initialize(source_path:)
      super

      @source_path = source_path
    end

    def call
      names = YAML.load_file(source_path).each_with_object({}) { |r, h| h[r['itemID']] = r['itemName'] }
      info("Loaded #{names.count} name(s) from #{source_path}")
      names
    end

    private

    attr_reader :source_path
  end
end
