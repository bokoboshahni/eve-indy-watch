# frozen_string_literal: true

module Admin
  class StructuresController < AdminController
    include Filterable

    before_action :find_structure, only: %i[show edit update market_order_batches]

    def index
      store_filters!('Structure')

      scope = Structure.includes(owner: :alliance)
      @filter = filter_for('Structure')
      @pagy, @structures= pagy(@filter.apply!(scope))

      if turbo_frame_request?
        render partial: 'structures', locals: { structures: @structures, filter: @filter, paginator: @pagy }
      else
        render :index
      end
    end

    def show; end

    def edit; end

    def update
      if @structure.update(structure_params)
        flash[:success] = 'Structure settings updated sucessfully.'
        redirect_to admin_structure_path(@structure)
      else
        render :edit
      end
    end

    def market_order_batches
      @pagy, @market_order_batches = pagy(@structure.market_order_batches.order(time: :desc))
    end

    private

    def find_structure
      @structure = Structure.find(params[:id], params[:structure_id])
    end

    def structure_params
      params.require(:structure).permit(:market_order_sync_enabled, :esi_authorization_id)
    end
  end
end
