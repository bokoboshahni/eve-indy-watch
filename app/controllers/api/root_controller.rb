# frozen_string_literal: true

module API
  class RootController < APIController
    before_action :doorkeeper_authorize!

    def index
      render json: {
        authenticated_user_url: api_user_url
      }.to_json
    end
  end
end
