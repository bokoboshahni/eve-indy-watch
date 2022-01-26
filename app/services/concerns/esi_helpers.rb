# frozen_string_literal: true

require 'esi/client'

module ESIHelpers
  extend ActiveSupport::Concern

  include RetriableHelpers

  def esi
    @esi ||= ESI::Client.new(user_agent: Rails.application.config.x.esi.user_agent)
  end

  def esi_authorize!(authorization)
    authorization.refresh_token!
    esi.authorize(authorization.access_token)
  end

  def location_type(id)
    case id
    when 60_000_000..64_000_000
      'Station'
    else
      'Structure'
    end
  end
end
