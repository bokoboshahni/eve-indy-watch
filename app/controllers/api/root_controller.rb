# frozen_string_literal: true

module API
  class RootController < APIController
    before_action :doorkeeper_authorize!

    def index
      render json: {
      }.to_json
    end
  end
end
