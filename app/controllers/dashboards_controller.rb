# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @fittings = current_alliance.fittings.pinned.order(:name)
  end
end
