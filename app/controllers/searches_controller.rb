class SearchesController < ApplicationController
  def show
    @results = GlobalSearch.call(params[:query])
  end
end
