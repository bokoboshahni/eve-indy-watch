# frozen_string_literal: true

class ProcurementOrdersController < ApplicationController
  include Filterable

  before_action :authenticate_user!
  before_action :find_order, only: %i[show edit update destroy accept release receive redraft]

  def index
    authorize(ProcurementOrder)
    # store_filters!('ProcurementOrder')

    scope =
      case params[:tab]
      when 'available'
        policy_scope(ProcurementOrder.kept.available)
      when 'drafts'
        policy_scope(ProcurementOrder.kept.draft)
      when 'in_progress'
        policy_scope(ProcurementOrder.kept.in_progress)
      when 'delivered'
        policy_scope(ProcurementOrder.kept.delivered)
      else
        policy_scope(ProcurementOrder.kept.available)
      end

    # @filter = filter_for('ProcurementOrder')
    # @pagy, @orders = pagy(@filter.apply!(scope))

    @pagy, @orders = pagy(scope)

    if turbo_frame_request?
      # render partial: 'orders', locals: { orders: @orders, filter: @filter, paginator: @pagy }
      render partial: 'orders', locals: { orders: @orders, paginator: @pagy }
    else
      render :index
    end
  end

  def new
    @order = ProcurementOrder.new
    authorize(@order)
  end

  def create
    @order = ProcurementOrder.new(create_params)
    authorize(@order)

    if publishing?
      @order.status = :available
      @order.published_at = Time.zone.now
    else
      @order.status = :draft
    end

    if @order.save
      flash[:success] = "Procurement order ##{@order.number} #{publishing? ? 'published' : 'created'} successfully."
      redirect_to procurement_order_path(@order)
    else
      flash[:error] = "Error #{publishing? ? 'publishing' : 'creating'} procurement order."
      set_errors!(@order.errors)
      render :new
    end
  end

  def show; end

  def update
    if publishing?
      @order.status = :available
      @order.published_at = Time.zone.now
    end

    if @order.update(update_params)
      flash[:success] = "Procurement order ##{@order.number} #{publishing? ? 'published' : 'saved'} successfully."
      redirect_to procurement_order_path(@order)
    else
      flash[:error] = "Error #{publishing? ? 'publishing' : 'saving'} procurement order #{@order.number}."
      @order.status = :draft
      set_errors!(@order.errors)
      render :show
    end
  end

  def destroy
    if %w[draft available].include?(@order.status)
      @order.discard
      flash[:success] = "Procurement order ##{@order.number} has been deleted."
      redirect_to procurement_orders_path
    else
      flash[:error] = "Procurement order ##{@order.number} is #{@order.status.humanize.downcase} and cannot be moved to trash."
      redirect_to procurement_order_path(@order)
    end
  end

  def accept
    if @order.accept!(current_user.character)
      flash[:success] = "Procurement order #{@order.number} accepted."
      redirect_to procurement_order_path(@order)
    else
      flash[:error] = "Error accepting procurement order #{@order.number}."
      set_errors!(@order.errors)
      render :show
    end
  end

  def release
    if @order.release!
      flash[:success] = "Procurement order #{@order.number} released."
      redirect_to procurement_orders_path
    else
      flash[:error] = "Error releasing procurement order #{@order.number}."
      set_errors!(@order.errors)
      render :show
    end
  end

  def receive
    if @order.receive!
      flash[:success] = "Delivery of procurement order #{@order.number} confirmed."
      redirect_to procurement_orders_path
    else
      flash[:error] = "Error confirming delivery for procurement order #{@order.number}."
      set_errors!(@order.errors)
      render :show
    end
  end

  def redraft
    if @order.redraft!
      flash[:success] = "Procurement order #{@order.number} moved back to draft."
    else
      flash[:error] = "Error movinv procurement order #{@order.number} back to draft."
      set_errors!(@order.errors)
    end

    redirect_to procurement_order_path(@order)
  end

  def item
    type = Type.find(params[:type_id])
    appraisal_pricing = type.market_stats(main_alliance.appraisal_market)
    alliance_pricing = type.market_stats(main_alliance.main_market)
    json = type.as_json(include: %i[category group market_group]).merge(
      icon_url: type.icon_url,
      appraisal_pricing: appraisal_pricing,
      appraisal_buy_price: appraisal_pricing.dig(:buy, :price_max),
      appraisal_sell_price: appraisal_pricing.dig(:sell, :price_min),
      appraisal_mid_price: appraisal_pricing[:mid_price],
      alliance_pricing: alliance_pricing,
      alliance_buy_price: alliance_pricing.dig(:buy, :price_max),
      alliance_sell_price: alliance_pricing.dig(:sell, :price_min),
      alliance_mid_price: alliance_pricing[:mid_price]
    )

    render json: JSON.pretty_generate(json)
  end

  private

  def find_order
    @order = policy_scope(ProcurementOrder).find(params[:id] || params[:procurement_order_id])
    authorize(@order)
  end

  def publishing?
    params[:commit] == 'Publish'
  end

  def create_params
    params.require(:procurement_order).permit(
      :appraisal_url,
      :requester_gid, :deliver_by,
      :location_id, :notes, :bonus, :multiplier,
      items_attributes: %i[type_id quantity_required price]
    )
  end

  def update_params
    params.require(:procurement_order).permit(
      :appraisal_url,
      :requester_gid, :deliver_by,
      :location_id, :notes, :bonus, :multiplier,
      items_attributes: %i[type_id quantity_required price _destroy id]
    )
  end
end
