# frozen_string_literal: true

class ResolveAndSyncEntity < ApplicationService
  def initialize(id)
    super

    @id = id
  end

  def call
    case id
    when 0
      nil
    when 90_000_000..97_999_999
      Character::SyncFromESI.call(id)
    when 1_000_000..2_000_000, 98_000_000..98_999_999
      Corporation::SyncFromESI.call(id)
    when 99_000_000..99_999_999
      Alliance::SyncFromESI.call(id)
    when 100_000_000..2_099_999_999
      begin
        Character::SyncFromESI.call(id)
      rescue ESI::Errors::NotFoundError
        begin
          Corporation::SyncFromESI.call(id)
        rescue ESI::Errors::NotFoundError
          Alliance::SyncFromESI.call(id)
        end
      end
    end
  end

  private

  attr_reader :id
end
