# frozen_string_literal: true

class TestLoginsController < ApplicationController
  def create
    session[:current_user_id] = params[:user_id]
    redirect_to(root_path)
  end

  def destroy
    session[:current_user_id] = nil
    redirect_to(root_path)
  end
end
