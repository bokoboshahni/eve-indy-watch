class TypesController < ApplicationController
  include Filterable

  before_action :authenticate_user!

  def index
    store_filters!('Type')

    scope = Type.marketable.includes(:market_group, group: :category)
    @filter = filter_for('Type')
    @pagy, @types = pagy(@filter.apply!(scope))

    if turbo_frame_request?
      render partial: 'types', locals: { types: @types, filter: @filter, paginator: @pagy }
    else
      render :index
    end
  end

  def show
    @market = Market.find(market_id)
    @type = Type.find(params[:id])
    @buy_orders = @market.latest_orders.includes(:location).where(kind: 'buy', type_id: @type.id).order(price: :desc)
    @sell_orders = @market.latest_orders.includes(:location).where(kind: 'sell', type_id: @type.id).order(price: :asc)
  end

  private

  def market_id
    params.fetch(:market_id, current_alliance.main_market_id)
  end
end
