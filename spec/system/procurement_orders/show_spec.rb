# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Procurement order details', type: :system do
  let(:supplier_user) { create(:user, roles: %w[character.orders.viewer character.orders.supplier]) }

  before do
    alliance = create(:alliance, id: Rails.application.config.x.app.main_alliance_id)
    main_market = alliance.create_main_market(name: Faker::Finance.stock_market)
    appraisal_market = alliance.create_appraisal_market(name: Faker::Finance.stock_market)

    market_time = Faker::Time.between(from: 5.minutes.ago, to: Time.zone.now).to_formatted_s(:number)

    type = order.items.first.type
    type_stats = {
      buy: { price_max: Faker::Number.decimal(l_digits: 2, r_digits: 2) },
      sell: { price_min: Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    }

    redis = Kredis.redis(config: :markets_writer)
    redis.set("markets.#{main_market.id}.latest", market_time)
    redis.set("markets.#{main_market.id}.#{market_time}.types.#{type.id}.stats", Oj.dump(type_stats))
    redis.set("markets.#{appraisal_market.id}.latest", market_time)
    redis.set("markets.#{appraisal_market.id}.#{market_time}.types.#{type.id}.stats", Oj.dump(type_stats))

    log_in(supplier_user.id)
  end

  context 'with an available order' do
    let(:order) { create(:available_order, requester: supplier_user.alliance) }

    before { visit procurement_order_path(order) }

    it 'shows the order number' do
      expect(page).to have_text("Order ##{order.number} is currently waiting for a supplier.")
    end
  end
end
