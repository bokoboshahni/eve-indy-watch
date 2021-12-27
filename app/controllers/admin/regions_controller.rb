# frozen_string_literal: true

module Admin
  class RegionsController < AdminController
    before_action :find_region, only: %i[show edit update market_order_batches]

    def index
      @regions = Region.order(:name)
    end

    def show; end

    def edit; end

    def update
      if @region.update(region_params)
        flash[:success] = 'Region settings updated sucessfully.'
        redirect_to admin_region_path(@region)
      else
        render :edit
      end
    end

    def market_order_batches
      @pagy, @market_order_batches = pagy(@region.market_order_batches.order(time: :desc))
    end

    private

    def find_region
      @region = Region.find(params[:id] || params[:region_id])
    end

    def region_params
      params.require(:region).permit(:market_order_sync_enabled, :esi_authorization_id)
    end
  end
end
