# frozen_string_literal: true

module API
  class MarketsController < APIController
    before_action -> { doorkeeper_authorize!('markets.read') }, only: %i[index show]

    def index
      @markets = Market.all.order(:name)
    end

    def show
      @market = Market.find(params[:id])
    end
  end
end
