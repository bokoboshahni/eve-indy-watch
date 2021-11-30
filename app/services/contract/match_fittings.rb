class Contract < ApplicationRecord
  class MatchFittings < ApplicationService
    def initialize(contract, fittings)
      super

      @contract = contract
      @fittings = fittings
    end

    def call
      contract_items = contract.flattened_items
      contract_fittings = fittings.each_with_object([]) do |fitting, a|
        fitting_items = fitting.flattened_items
        contract_item_qty = fitting_items.each_with_object([]) do |item, h|
          item_id = item.id
          qty = item.quantity

          unless contract_items[item_id]
            h[item_id] = 0
            next
          end

          h[item_id] = contract_items[item_id] / qty
        end

        contract_qty = contract_item_qty.sort.each_with_object(0) { |i, k| k = i if contract_item_qty.all? { |j| i >= j } }
        a << { contract_id: contract_id, fitting_id: fitting_id, quantity: contract_qty } if contract_qty > 0
        debug("Contract #{contract_id} contains #{contract_qty} instance(s) of fitting #{fitting_name} (#{fitting_id})"
      end

      results = ContractFitting.import(
        contract_fittings,
        track_validation_failures: true,
        on_duplicate_key_update: {
          conflict_target: %i[contract_id fitting_id],
          columns: :all
        }
      )
      results.failed_instances.each { |i| error i.last.errors.full_messages }
      debug("Contract #{contract_id} matched #{contract_fittings.count} fitting(s) for corporation #{corporation_id}")
    end

    private

    attr_reader :contract, :fittings

    delegate :id, to: :contract, prefix: true
    delegate :id, to: :corporation, prefix: true
    delegate :id, :name, to: :fitting, prefix: true

    def corporation
      contract.issuer_corporation
    end
  end
end
