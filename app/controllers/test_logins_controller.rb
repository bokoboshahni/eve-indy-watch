# frozen_string_literal: true

class TestLoginsController < ApplicationController
  def show; end

  def create
    user = User.find(params[:user_id])

    session[:current_user_id] = user.id
    redirect_to(root_path)
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to(root_path)
  end
end
