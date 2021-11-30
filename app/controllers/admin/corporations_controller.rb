# frozen_string_literal: true

module Admin
  class CorporationsController < AdminController
    before_action :find_corporation, only: %i[show edit update]

    def index
      @corporations = Corporation.player.order(:name)
    end

    def show; end

    def edit; end

    def update
      if @corporation.update(corporation_params)
        flash[:success] = 'Alliance settings updated sucessfully.'
        redirect_to admin_corporation_path(@corporation)
      else
        render :edit
      end
    end

    private

    def find_corporation
      @corporation = Corporation.find(params[:id])
    end

    def corporation_params
      params.require(:corporation).permit(:contract_sync_enabled, :esi_authorization_id)
    end
  end
end
