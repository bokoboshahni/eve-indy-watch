# frozen_string_literal: true

class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_beta_tester!, only: :beta

  def show
    @fittings = main_alliance.fittings.includes(:contract_fittings, :contracts).pinned.order(:name)
  end

  def beta
    @props = dashboard_props

    render :beta, layout: 'beta'
  end

  private

  def dashboard_props
    {
      site: {
        logo_url: main_alliance_logo_url,
        name: site_name
      },
      user: {
        corporation_name: current_user.corporation_name,
        name: current_user.name,
        avatar_url: current_user.portrait_url_256
      }
    }
  end
end
