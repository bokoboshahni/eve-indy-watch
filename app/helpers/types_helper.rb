module TypesHelper
  def market_order_range(val)
    if val.to_i.to_s == val
      return pluralize(val.to_i, 'jump')
    elsif val == 'solarsystem'
      return 'System'
    else
      val.titleize
    end
  end
end
