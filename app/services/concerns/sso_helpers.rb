# frozen_string_literal: true

module SSOHelpers
  extend ActiveSupport::Concern

  included do
    attr_reader :auth_info
  end

  def initialize(auth_info)
    @auth_info = auth_info
  end

  protected

  def sync_character!
    Character::SyncFromESI.call(uid)
  end

  def sync_alliance!(alliance_id)
    Alliance::SyncFromESI.call(alliance_id)
  end

  def sync_corporation!(corporation_id)
    Corporation::SyncFromESI.call(corporation_id)
  end

  def uid
    auth_info.uid.to_i
  end
end
