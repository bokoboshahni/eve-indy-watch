# frozen_string_literal: true

module API
  class MarketTypesController < APIController
    before_action -> { doorkeeper_authorize!('markets.read') }, only: %i[index show]
    before_action :find_market
    before_action :find_type, only: %i[show stats]

    def index
    end

    def show
    end

    def stats
    end

    private

    def find_market
      @market = Market.find(params[:market_id])
    end

    def find_type
      @type = Type.marketable.find(params[:id])
    end
  end
end
