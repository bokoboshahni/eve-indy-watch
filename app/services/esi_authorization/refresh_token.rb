# frozen_string_literal: true

class ESIAuthorization < ApplicationRecord
  class RefreshToken < ApplicationService
    def initialize(esi_authorization)
      super

      @esi_authorization = esi_authorization
    end

    def call
      return esi_authorization unless current_token.expired?

      new_token = current_token.refresh!
      esi_authorization.update!(
        access_token: new_token.token,
        refresh_token: new_token.refresh_token,
        expires_at: Time.zone.at(new_token.expires_at).to_datetime
      )
      logger.debug("Refreshed ESI authorization for character \"#{character_name}\" (#{character_id})")
      esi_authorization
    end

    private

    attr_reader :esi_authorization

    delegate :character, to: :esi_authorization
    delegate :id, :name, to: :character, prefix: true
    delegate :client_id, :client_secret, :oauth_url, to: :esi_config

    def current_token
      @current_token ||= OAuth2::AccessToken.from_hash(client,
                                                       access_token: esi_authorization.access_token,
                                                       refresh_token: esi_authorization.refresh_token,
                                                       expires_at: esi_authorization.expires_at)
    end

    def client
      @client ||= OAuth2::Client.new(client_id, client_secret, site: oauth_url, token_url: '/v2/oauth/token')
    end
  end
end
