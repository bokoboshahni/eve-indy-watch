# frozen_string_literal: true

module Admin
  class CorporationsController < AdminController
    include Filterable

    before_action :find_corporation, only: %i[show edit update]

    def index
      store_filters!('Corporation')

      scope = Corporation.includes(:alliance)
      @filter = filter_for('Corporation')
      @pagy, @corporations= pagy(@filter.apply!(scope))

      if turbo_frame_request?
        render partial: 'corporations', locals: { corporations: @corporations, filter: @filter, paginator: @pagy }
      else
        render :index
      end
    end

    def show; end

    def edit; end

    def update
      if @corporation.update(corporation_params)
        flash[:success] = 'Corporation settings updated sucessfully.'
        redirect_to admin_corporation_path(@corporation)
      else
        render :edit
      end
    end

    private

    def find_corporation
      @corporation = authorize(Corporation.find(params[:id]))
    end

    def corporation_params
      params.require(:corporation).permit(:contract_sync_enabled, :esi_authorization_id)
    end
  end
end
