# frozen_string_literal: true

class Fitting < ApplicationRecord
  class ImportFromEFTFile < ApplicationService
    def initialize(file, owner:)
      super

      @file = file
      @owner = owner
    end

    def call
      fitting, errors = ParseEFT.call(File.read(file))

      record = Fitting.find_or_initialize_by(name: fitting[:name])
      record.transaction do
        if record.persisted?
          record.items.destroy_all
          record.attributes = record.attributes.merge(fitting)
        else
          record.attributes = fitting.merge(owner:)
        end
        record.save
      end
      record
    end

    private

    attr_reader :file, :owner
  end
end
