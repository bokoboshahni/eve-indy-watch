# frozen_string_literal: true

class APIController < ApplicationController
  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def doorkeeper_authorize_and_track!(*scopes)
    doorkeeper_authorize!(*scopes)
  end
end
