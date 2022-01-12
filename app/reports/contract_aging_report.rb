# frozen_string_literal: true

class ContractAgingReport < ApplicationReport
  self.title = 'Contract Aging'

  def run
    Fitting.includes(contract_fittings: :contract).order(:name)
  end
end
