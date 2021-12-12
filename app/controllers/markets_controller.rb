# frozen_string_literal: true

class MarketsController < ApplicationController
  before_action :authenticate_user!
end
