# frozen_string_literal: true

class ContractsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @contracts = pagy(Contract.includes(:fittings).where(assignee_id: main_alliance_id, status: 'outstanding', type: 'item_exchange', esi_items_exception: nil).order(
                               :title, :issued_at
                             ))

    if turbo_frame_request?
      render partial: 'contracts', locals: { contracts: @contracts, paginator: @pagy }
    else
      render :index
    end
  end

  def show
    @contract = Contract.includes(:fittings, :items).find(params[:id])
  end
end
