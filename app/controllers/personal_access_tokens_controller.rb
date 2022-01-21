# frozen_string_literal: true

class PersonalAccessTokensController < ApplicationController
  before_action :authenticate_user!
  before_action :find_pat, only: %i[destroy]

  layout 'settings'

  def index
    @pats = policy_scope(current_user.personal_access_tokens.order(created_at: :desc))
  end

  def new
    @pat = OauthAccessToken.new
  end

  def create
    create_params[:scopes] = create_params[:scopes].reject { |s| Doorkeeper.config.scopes.exclude?(s) }
    @pat_application = current_user.personal_access_token_applications.build(create_params.slice(:scopes))
    @pat = @pat_application.access_tokens.build(create_params.merge(resource_owner_id: current_user.id))

    if @pat_application.save
      flash[:success] = "Personal access token created successfully. Copy the token value because it will only be shown once: #{@pat.token}"
      redirect_to settings_personal_access_tokens_path
    else
      flash[:error] = 'Error creating personal access token.'
      render :new
    end
  end

  def show; end

  def destroy
    @pat.destroy
    flash[:success] = 'Personal access token successfully deleted.'
    redirect_to settings_personal_access_tokens_path
  end

  private

  def find_pat
    @pat = authorize(current_user.personal_access_tokens.find(params[:id]))
  end

  def create_params
    @create_params ||= params.require(:oauth_access_token).permit(:description, scopes: [])
  end
end
