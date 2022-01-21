json.market_id @market.id
json.type_id @type.id

unless @type.market_stats(@market).empty?
  json.time @type.market_stats(@market)[:time].to_datetime.to_s(:iso8601)
  json.buy @type.market_stats(@market)[:buy]
  json.sell @type.market_stats(@market)[:sell]
  json.buy_sell_spread @type.market_stats(@market)[:buy_sell_spread]
  json.buy_price @type.market_stats(@market).dig(:buy, :price_max)
  json.sell_price @type.market_stats(@market).dig(:sell, :price_min)
  json.split_price @type.market_stats(@market)[:mid_price]

  json.depth do
    @type.market_stats(@market)[:depth].each do |price, volumes|
      json.child! do
        json.price price
        json.buy volumes[:buy]
        json.sell volumes[:sell]
      end
    end
  end

  json.flow do
    @type.market_stats(@market)[:flow].each do |price, volumes|
      json.child! do
        json.price price
        json.buy volumes[:buy]
        json.sell volumes[:sell]
      end
    end
  end
end
