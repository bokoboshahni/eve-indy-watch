# frozen_string_literal: true

require 'omniauth/strategies/eve_online_sso'
require 'ext/omniauth/strategies/eve_online_sso'

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :eve_online_sso,
           Rails.application.config.x.esi.client_id,
           Rails.application.config.x.esi.client_secret,
           strategy_class: OmniAuth::Strategies::EveOnlineSso,
           name: 'eve'
end
