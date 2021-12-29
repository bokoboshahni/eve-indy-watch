# frozen_string_literal: true

class ContractsController < ApplicationController
  include Filterable

  before_action :authenticate_user!
  before_action :find_contract, only: %i[show list_fittings_card]

  def index
    store_filters!('Contract')

    scope = Contract.item_exchange.outstanding.assigned_to(main_alliance_id)
    @filter = filter_for('Contract')
    @pagy, @contracts = pagy(@filter.apply!(scope))

    if turbo_frame_request?
      render partial: 'contracts', locals: { contracts: @contracts, filter: @filter, paginator: @pagy }
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
