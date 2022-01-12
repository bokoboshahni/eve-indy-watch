# frozen_string_literal: true

class ContractItemsInaccessibleReport < ApplicationReport
  self.title = 'Open Contracts with Inaccessible Items'

  def run
    Contract.outstanding.items_inaccessible.joins(:issuer, :issuer_corporation)
            .order('corporations.name ASC, characters.name ASC, title ASC')
  end
end
