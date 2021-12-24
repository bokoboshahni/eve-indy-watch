namespace :data do
  task backfill_contract_related_names: :environment do
    Contract.transaction do
      contracts =
        Contract.where.not(start_location_id: nil).where(start_location_name: nil).or(
          Contract.where.not(end_location_id: nil).where(end_location_name: nil)).or(
            Contract.where.not(acceptor_id: nil).where(acceptor_name: nil)).or(
              Contract.where.not(assignee_id: nil).where(assignee_name: nil))
      contracts.each do |c|
        c.acceptor_name = c.acceptor.name if c.acceptor
        c.assignee_name = c.assignee.name if c.assignee
        c.start_location_name = c.start_location.name if c.start_location
        c.end_location_name = c.end_location.name if c.end_location
        c.save!
      end
    end
  end

  task backfill_fitting_markets: :environment do
    Fitting.transaction do
      Fitting.find_each do |fitting|
        fitting_markets = [
          { market_id: fitting.owner.main_market_id, contract_stock_level_enabled: true, market_stock_level_enabled: true },
          { market_id: fitting.owner.appraisal_market_id, contract_stock_level_enabled: false, market_stock_level_enabled: true },
        ]
        fitting.fitting_markets.create!(fitting_markets)
      end
    end
  end
end
