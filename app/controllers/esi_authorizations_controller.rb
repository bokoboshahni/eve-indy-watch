# frozen_string_literal: true

class ESIAuthorizationsController < ApplicationController
  before_action :find_esi_authorization, only: %i[destroy]
  before_action :authorize_admin!

  layout 'settings'

  def index
    @esi_authorizations = current_user.esi_authorizations
  end

  def create
    state = session['omniauth.state'] = SecureRandom.hex
    redirect_to oauth.auth_code.authorize_url(redirect_uri: redirect_uri, scope: scopes.join(' '), state: state)
  end

  def destroy
    @esi_authorization.destroy
    flash[:success] = "ESI authorization for #{@esi_authorization.character.name} successfully revoked."
    redirect_to settings_esi_authorizations_path
  end

  private

  delegate :client_id, :client_secret, :oauth_url, :redirect_uri, :scopes, to: :esi_config

  def find_esi_authorization
    @esi_authorization = current_user.esi_authorizations.find(params[:id])
  end

  def esi_config
    Rails.application.config.x.esi
  end

  def oauth
    @oauth = OAuth2::Client.new(client_id, client_secret, site: oauth_url, authorize_url: 'v2/oauth/authorize')
  end
end
