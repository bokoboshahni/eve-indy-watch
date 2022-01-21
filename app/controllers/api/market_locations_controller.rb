# frozen_string_literal: true

module API
  class MarketLocationsController < ApplicationController
    before_action -> { doorkeeper_authorize!('markets.read') }, only: %i[index show]

    def index; end

    def show; end
  end
end
