class Fitting < ApplicationRecord
  class ParseEFT < ApplicationService
    class Error < StandardError; end

    class InvalidHeaderError < Error; end

    def initialize(raw)
      super

      @raw = raw
    end

    def call
      lines = prepare_lines
      type, name = process_header(lines.shift)
      items = process_items(lines)

      {
        type_id: type.id,
        name: name,
        original: raw,
        items_attributes: items
      }
    end

    private

    NAME_CHARS = '[^,/\[\]]'
    MODULE_PATTERN = %r{\A(?<type>#{NAME_CHARS}+?)(,\s*(?<charge>#{NAME_CHARS}+?))?\z}
    CARGO_PATTERN = %r{\A(?<type>#{NAME_CHARS}+?)\s+x(?<amount>\d+?)\z}
    STUB_PATTERN = %r{\A\[.+?\]\z}

    attr_reader :raw, :fitting

    def prepare_lines
      raw.strip.encode(universal_newline: true).split("\n").map(&:strip)
    end

    def process_header(line)
      match = line.match(%r{\A\[(?<type>[^,]+),\s*(?<name>[^,/\[\]]+)\]\z})

      raise InvalidHeaderError.new(line) unless match

      type = Type.find_by!(name: match[:type].strip)
      name = match[:name].strip

      [type, name]
    end

    def process_items(lines)
      lines.each_with_object([]) do |line, a|
        next if line.blank? || line =~ STUB_PATTERN

        match = line.match(CARGO_PATTERN)
        if match
          type = find_type(match[:type])
          a << { type_id: type.id, quantity: match[:amount].to_i }
          next
        end

        match = line.match(MODULE_PATTERN)
        if match
          type = find_type(match[:type])
          a << { type_id: type.id, quantity: 1 }
          next
        end

        warn "Line cannot be parsed: #{line}"
      end
    end

    def find_type(name)
      type = Type.find_by(name: name)

      raise ParseError.new("Type not found: #{name}") unless type

      type
    end
  end
end
