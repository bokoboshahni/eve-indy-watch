# frozen_string_literal: true

module API
  class MeController < APIController
    before_action -> { doorkeeper_authorize_and_track!('account.read') }, only: :show

    def show
      render json: current_resource_owner.to_json
    end
  end
end
