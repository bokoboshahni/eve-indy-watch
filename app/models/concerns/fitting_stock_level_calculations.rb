# frozen_string_literal: true

module FittingStockLevelCalculations
  extend ActiveSupport::Concern

  def as_json(_options = nil)
    super.merge(
      total_quantity:
    )
  end

  def contract_problematic_quantity
    return unless contract_match_quantity.to_i && contract_total_quantity.to_i.positive?

    contract_total_quantity.to_i - contract_match_quantity.to_i
  end

  def contract_quality
    return unless contract_match_quantity.to_d && contract_total_quantity.to_d.positive?

    (contract_match_quantity.to_d / contract_total_quantity.to_d) * 100.0
  end

  def total_quantity
    contract_match_quantity.to_i + market_quantity.to_i
  end

  def limiting_items
    @limiting_items ||=
      begin
        ids = items.each_with_object([]) { |i, a| a << i.type_id if i[:fitting_quantity].zero? }
        ids.empty? ? [] : Type.find(ids)
      end
  end

  def market_split_price
    return unless market_buy_price && market_sell_price

    [
      market_buy_price,
      market_sell_price
    ].sum / 2.0
  end

  def at_stock?
    total_quantity >= fitting.reorder_point
  end

  def under_stock?
    total_quantity < fitting.reorder_point
  end

  def out_of_stock?
    total_quantity.zero?
  end
end
