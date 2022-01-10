# frozen_string_literal: true

class AutocompletesController < ApplicationController
  before_action :authenticate_user!

  def types
    @results = Type.search_by_name(params[:q]).order(:name)

    render partial: 'results', locals: { results: @results }
  end

  def market_types
    @results = Type.search_by_name(params[:q]).marketable.order(:name)

    render partial: 'results', locals: { results: @results }
  end
end
