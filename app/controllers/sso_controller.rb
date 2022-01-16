# frozen_string_literal: true

class SSOController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]

  def new
    if logged_in?
      redirect_to dashboard_path
    else
      repost '/auth/eve', options: { authenticity_token: :auto }
    end
  end

  def create
    if scopes.empty?
      authenticate
    else
      create_esi_authorization
    end
  end

  def failure
    flash[:error] = 'Authentication failed.'
    redirect_to(request.referer || root_path)
  end

  def destroy
    session[:current_user_id] = nil
    flash[:success] = 'Logged out successfully.'
    redirect_to root_path
  end

  private

  def authenticate
    user = User::AuthenticateFromSSO.call(auth_info)
    session[:current_user_id] = user.id
    flash[:success] = "Welcome back, #{user.name}"
    redirect_to(session[:redirect_to] || dashboard_path)
    session[:redirect_to] = nil
  rescue Character::SyncFromESI::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to sync character.'
  rescue User::AuthenticateFromSSO::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to log in.'
    redirect_to root_path
  end

  def create_esi_authorization
    redirect_to root_path unless logged_in?
    ESIAuthorization::CreateFromSSO.call(auth_info, current_user)
    flash[:success] = 'Character authorized successfully.'
    redirect_to settings_esi_authorizations_path
  rescue ESIAuthorization::CreateFromSSO::Error => e
    Rails.logger.error e
    flash[:error] = 'Failed to authorize character.'
    redirect_to settings_esi_authorizations_path
  end

  def auth_info
    request.env['omniauth.auth']
  end

  def scopes
    auth_info.info.scopes.split
  end
end
