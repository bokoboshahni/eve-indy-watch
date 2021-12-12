# frozen_string_literal: true

class Fitting < ApplicationRecord
  class ParseEFT < ApplicationService
    class Error < RuntimeError; end

    class InvalidHeaderError < Error; end

    def initialize(raw)
      super

      @raw = raw
      @errors = []
    end

    def call
      lines = prepare_lines
      type, name = process_header(lines.shift)
      items = parse_lines(lines)

      fitting = {
        type_id: type.id,
        name: name,
        original: raw,
        items_attributes: items
      }

      debug fitting[:items_attributes].inspect

      [fitting, errors]
    end

    private

    NAME_CHARS = '[^,/\[\]]'
    MODULE_PATTERN = %r{\A(?<type>#{NAME_CHARS}+?)(,\s*(?<charge>#{NAME_CHARS}+?))?(\s+(?<offline>/OFFLINE))?\z}
    CARGO_PATTERN = /\A(?<type>#{NAME_CHARS}+?)\s+x(?<amount>\d+?)\z/
    STUB_PATTERN = /\A\[.+?\]\z/

    attr_reader :errors, :raw

    def prepare_lines
      raw.strip.encode(universal_newline: true).split("\n").map(&:strip)
    end

    def process_header(line)
      match = line.match(/\A\[(?<type>[^,]+),\s*(?<name>[^,]+)\]\z/)

      raise InvalidHeaderError, line unless match

      type = Type.find_by!(name: match[:type].strip)
      name = match[:name].strip

      [type, name]
    end

    def parse_lines(lines)
      lines.each_with_object([]) do |line, a|
        next if line.blank? || line =~ STUB_PATTERN

        match = line.match(CARGO_PATTERN)
        if match
          type = find_type(match[:type])

          ((errors << { line: line, message: :invalid_type }) && next) unless type

          item = { type: type, quantity: match[:amount].to_i }
          a << item
          debug "Added item: #{item}"
          next
        end

        match = line.match(MODULE_PATTERN)
        if match
          type = find_type(match[:type])

          ((errors << { line: line, message: :invalid_type }) && next) unless type

          item = { type: type, quantity: 1, offline: match[:offline] }
          a << item
          debug "Added item: #{item}"
          next
        end

        errors << { line: line, message: :parse_error }
        debug("Parse error: #{line}")
        return
      end
    end

    def find_type(name)
      Type.find_by(name: name)
    end
  end
end
