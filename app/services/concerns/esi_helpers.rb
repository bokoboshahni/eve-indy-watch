# frozen_string_literal: true

require 'esi/client'

module ESIHelpers
  extend ActiveSupport::Concern

  def esi
    @esi ||= ESI::Client.new(user_agent: Rails.application.config.x.esi.user_agent,
                             cache: { store: Rails.cache, logger: Rails.logger,
                                      instrumenter: ActiveSupport::Notifications })
  end

  def esi_authorize!(authorization)
    authorization.refresh_token!
    esi.authorize(authorization.access_token)
  end
end
