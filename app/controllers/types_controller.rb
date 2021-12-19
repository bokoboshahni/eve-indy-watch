class TypesController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @types = pagy(Type.marketable.order(:name))

    if turbo_frame_request?
      render partial: 'types', locals: { types: @types, paginator: @pagy }
    else
      render :index
    end
  end

  def show
    @type = Type.find(params[:id])
  end
end
