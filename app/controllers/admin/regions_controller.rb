# frozen_string_literal: true

module Admin
  class RegionsController < AdminController
    include Filterable

    before_action :find_region, only: %i[show edit update]

    def index
      store_filters!('Region')

      scope = Region
      @filter = filter_for('Region')
      @pagy, @regions = pagy(@filter.apply!(scope))

      if turbo_frame_request?
        render partial: 'regions', locals: { users: @regions, filter: @filter, paginator: @pagy }
      else
        render :index
      end
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

    private

    def find_region
      @region = authorize(Region.find(params[:id] || params[:region_id]))
    end

    def region_params
      params.require(:region).permit(:esi_authorization_id)
    end
  end
end
