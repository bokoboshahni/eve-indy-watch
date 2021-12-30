# frozen_string_literal: true

module Admin
  class AlliancesController < AdminController
    include Filterable

    before_action :find_alliance, only: %i[show edit update]

    def index
      store_filters!('Alliance')

      scope = Alliance
      @filter = filter_for('Alliance')
      @pagy, @alliances = pagy(@filter.apply!(scope))

      if turbo_frame_request?
        render partial: 'alliances', locals: { users: @alliances, filter: @filter, paginator: @pagy }
      else
        render :index
      end
    end

    def show; end

    def edit; end

    def update
      if @alliance.update(alliance_params)
        flash[:success] = 'Alliance settings updated sucessfully.'
        redirect_to admin_alliance_path(@alliance)
      else
        render :edit
      end
    end

    private

    def find_alliance
      @alliance = authorize(Alliance.find(params[:id]))
    end

    def alliance_params
      params.require(:alliance).permit(:api_corporation_id, :zkb_sync_enabled, :main_market_id, :appraisal_market_id)
    end
  end
end
