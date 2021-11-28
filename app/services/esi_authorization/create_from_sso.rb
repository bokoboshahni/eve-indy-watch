# frozen_string_literal: true

class ESIAuthorization < ApplicationRecord
  class CreateFromSSO < ApplicationService
    class Error < RuntimeError; end

    class AlreadyInUseError < Error; end

    include SSOHelpers

    def initialize(auth_info, user)
      super(auth_info)
      @user = user
    end

    def call
      raise AlreadyInUseError, 'Character is already authorized to another user.' unless available?

      ActiveRecord::Base.transaction do
        character = sync_character!
        corporation = sync_corporation!(character.corporation_id)
        sync_alliance!(corporation.alliance_id) if corporation.alliance_id.present?
        return create_authorization!(character.id)
      end
    end

    private

    attr_reader :user

    delegate :id, to: :user, prefix: true

    def available?
      return true if user.esi_authorizations.exists?(character_id: uid)

      return false if ESIAuthorization.exists?(character_id: uid, user_id: user_id) # Character is authorized to any other account.

      true
    end

    def create_authorization!(character_id)
      authorization_attrs = {
        access_token: auth_info.credentials.token,
        expires_at: Time.zone.at(auth_info.credentials.expires_at).to_datetime,
        refresh_token: auth_info.credentials.refresh_token,
        scopes: auth_info.info.scopes.split(' '),
        user: user
      }
      authorization = ESIAuthorization.where(character_id: character_id).first_or_create!(authorization_attrs)
      authorization.update!(authorization_attrs)
      authorization
    end
  end
end
