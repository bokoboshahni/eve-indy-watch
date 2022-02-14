# frozen_string_literal: true

class ProcurementOrdersController < ApplicationController
  include Filterable

  before_action :authenticate_user!
  before_action :find_order, only: %i[show edit update destroy accept deliver undeliver release receive redraft list_items_card]

  def index # rubocop:disable Metrics/AbcSize
    authorize(ProcurementOrder)

    @pagy, @available_orders = pagy(policy_scope(ProcurementOrder.kept.available.order(updated_at: :desc)))
    @draft_orders = policy_scope(ProcurementOrder.kept.draft.order(updated_at: :desc))
    @in_progress_orders = policy_scope(ProcurementOrder.kept.in_progress.where.not(supplier: current_user.character).where(delivered_at: nil))
    @unconfirmed_orders = policy_scope(ProcurementOrder.kept.unconfirmed.where.not(supplier: current_user.character))
    @delivered_orders = policy_scope(ProcurementOrder.kept.delivered)
    @supplied_orders = policy_scope(current_user.character.supplied_procurement_orders.kept.in_progress_and_unconfirmed.order(accepted_at: :desc))
  end

  def history
    authorize(ProcurementOrder)
    # store_filters!('ProcurementOrder')

    scope =
      case params[:tab]
      when 'drafts'
        policy_scope(ProcurementOrder.kept.draft.order(updated_at: :desc))
      when 'delivered'
        policy_scope(ProcurementOrder.kept.delivered.order(delivered_at: :desc))
      else
        policy_scope(ProcurementOrder.kept.delivered.order(delivered_at: :desc))
      end

    # @filter = filter_for('ProcurementOrder')
    # @pagy, @orders = pagy(@filter.apply!(scope))

    @pagy, @orders = pagy(scope)

    if turbo_frame_request?
      # render partial: 'orders', locals: { orders: @orders, filter: @filter, paginator: @pagy }
      render partial: 'orders_history', locals: { orders: @orders, paginator: @pagy }
    else
      render :history
    end
  end

  def new
    @order = ProcurementOrder.new(visibility: :everyone, requester: current_user.character)
    authorize(@order)
  end

  def create
    @order = ProcurementOrder.new(create_params)
    authorize(@order)

    @order.publish if publishing?

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
    @order.publish if publishing?

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
    @order.supplier = current_user.character
    @order.estimated_completion_at = params[:procurement_order][:estimated_completion_at]

    if @order.accept!
      flash[:success] = "Procurement order #{@order.number} accepted."
      redirect_to procurement_order_path(@order)
    else
      flash[:error] = "Error accepting procurement order #{@order.number}."
      set_errors!(@order.errors)
      render :show
    end
  end

  def deliver
    if @order.deliver!
      flash[:success] = "Procurement order #{@order.number} delivered."
      redirect_to procurement_order_path(@order)
    else
      flash[:error] = "Error delivering procurement order #{@order.number}."
      set_errors!(@order.errors)
      render :show
    end
  end

  def undeliver
    if @order.undeliver!
      flash[:success] = "Procurement order #{@order.number} undelivered."
      redirect_to procurement_order_path(@order)
    else
      flash[:error] = "Error undelivering procurement order #{@order.number}."
      set_errors!(@order.errors)
      @order.delivered_at = @order.delivered_at_was
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
      flash[:error] = "Error moving procurement order #{@order.number} back to draft."
      set_errors!(@order.errors)
    end

    redirect_to procurement_order_path(@order)
  end

  def item
    type = Type.find(params[:type_id])
    order_id = params[:order_id]
    price = type.market_sell_price(main_alliance.appraisal_market)
    if order_id.present?
      order = ProcurementOrder.find(order_id)
      @item = order.items.build(type: type, price: price, quantity_required: 1)
    else
      @item = ProcurementOrderItem.new(type: type, price: price, quantity_required: 1)
    end

    render partial: 'new_item', item: @item
  end

  def list_items_card
    @items = @order.items.includes(:type)

    render layout: false
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
      :requester_gid, :target_completion_at, :visibility,
      :location_id, :notes, :bonus, :multiplier,
      items_attributes: %i[type_id quantity_required price]
    )
  end

  def update_params
    params.require(:procurement_order).permit(
      :appraisal_url,
      :requester_gid, :target_completion_at, :visibility,
      :location_id, :notes, :bonus, :multiplier,
      items_attributes: %i[type_id quantity_required price _destroy id]
    )
  end

  def accept_params
    params.require(:procurement_order).permit(:estimated_completion_at)
  end
end
