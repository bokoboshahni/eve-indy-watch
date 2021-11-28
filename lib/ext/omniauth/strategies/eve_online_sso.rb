# frozen_string_literal: true

require "omniauth-oauth2"
require "jwt"

module OmniAuth
  module Strategies
    class EveOnlineSso < OmniAuth::Strategies::OAuth2
      def raw_info
        @raw_info ||= JWT.decode(access_token.token, nil, false)
          .find { |element| element.keys.include?("sub") }.tap do |hash|
          hash["character_id"] = hash["sub"].split(":")[-1]
          hash["scopes"] = hash['scp'].present? ? [*hash["scp"]].join(" ") : ''
          hash["token_type"] = hash["sub"].split(":")[0].capitalize
          hash["expires_on"] = hash["exp"]
        end
      end
    end
  end
end

