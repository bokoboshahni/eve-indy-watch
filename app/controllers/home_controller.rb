# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    redirect_to dashboard_path if logged_in?
  end
end
