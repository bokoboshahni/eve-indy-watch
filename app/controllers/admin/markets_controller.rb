# frozen_string_literal: true

module Admin
  class MarketsController < AdminController
    include Filterable

    before_action :find_market, only: %i[show edit update destroy]

    def index
      store_filters!('Market')

      scope = Market
      @filter = filter_for('Market')
      @pagy, @markets = pagy(@filter.apply!(scope))

      if turbo_frame_request?
        render partial: 'markets', locals: { users: @markets, filter: @filter, paginator: @pagy }
      else
        render :index
      end
    end

    def new
    end

    def create
      if @market.create(market_params)
        flash[:success] = 'Market created successfully.'
        redirect_to admin_market_path(@market)
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @market.update(market_params)
        flash[:success] = 'Market settings updated sucessfully.'
        redirect_to admin_market_path(@market)
      else
        render :edit
      end
    end

    def destroy
    end

    private

    def find_market
      @market = Market.find(params[:id])
    end

    def market_params
      params.require(:market).permit(:name)
    end
  end
end
