# frozen_string_literal: true

class Location < ApplicationRecord
  class ResolveAndSync < ApplicationService
    def initialize(id, authorization)
      super

      @id = id.to_i
      @authorization = authorization
    end

    def call
      if id < 10_000_000_000
        return if Station.exists?(id: id)

        Station::SyncFromESI.call(id)
      else
        Structure::SyncFromESI.call(id, authorization)
      end
    end

    private

    attr_reader :id, :authorization
  end
end
