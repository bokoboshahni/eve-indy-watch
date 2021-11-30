# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!
end
