# frozen_string_literal: true

module Admin
  class AlliancesController < AdminController
    before_action :find_alliance, only: %i[show edit update]

    def index
      @alliances = Alliance.order(:name)
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
      @alliance = Alliance.find(params[:id])
    end

    def alliance_params
      params.require(:alliance).permit(:contract_corporation_id)
    end
  end
end
