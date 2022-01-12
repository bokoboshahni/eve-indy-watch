# frozen_string_literal: true

class ResolveAndSyncEntity < ApplicationService
  def initialize(id)
    super

    @id = id
  end

  def call # rubocop:disable Metrics/MethodLength
    Retriable.retriable on: [Character::SyncFromESI::Error, Corporation::SyncFromESI::Error,
                             Alliance::SyncFromESI::Error] do
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
        rescue Character::SyncFromESI::Error => e
          if e.cause.is_a?(ESI::Errors::NotFoundError)
            begin
              Corporation::SyncFromESI.call(id)
            rescue Corporation::SyncFromESI::Error => e
              Alliance::SyncFromESI.call(id) if e.cause_is_a?(ESI::Errors::NotFoundError)
            end
          end
        end
      end
    end
  end

  private

  attr_reader :id
end
