# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @fittings = main_alliance.fittings.includes(:contract_fittings, :contracts).pinned.order(:name)
  end
end
