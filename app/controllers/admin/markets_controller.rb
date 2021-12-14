# frozen_string_literal: true

module Admin
  class MarketsController < AdminController
    before_action :find_market, only: %i[show edit update destroy]

    def index
      @markets = Market.order(:name)
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
