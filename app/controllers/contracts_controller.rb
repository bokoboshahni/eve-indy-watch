# frozen_string_literal: true

class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_contract, only: %i[show list_fittings_card]

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
    fitting_id = params[:fitting_id] || @contract.contract_fittings.joins(:fitting).order('similarity desc, fittings.name asc').first
    @contract_fitting = @contract.contract_fittings.find_by(fitting_id: fitting_id)
  end

  def list_fittings_card
    @contract_fitting = @contract.contract_fittings.find_by(fitting_id: params[:fitting_id])

    render layout: false
  end

  private

  def find_contract
    @contract = Contract.includes(:fittings, :items).find(params[:id])
  end
end
