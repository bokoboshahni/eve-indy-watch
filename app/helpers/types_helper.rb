# frozen_string_literal: true

module TypesHelper
  def market_order_range(val)
    if val.to_i.to_s == val
      pluralize(val.to_i, 'jump')
    elsif val == 'solarsystem'
      'System'
    else
      val.titleize
    end
  end
end
