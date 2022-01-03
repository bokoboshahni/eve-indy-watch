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

  task retry_contracts_with_inaccessible_items: :environment do
    Contract.transaction do
      contracts = Contract.where.not(esi_items_exception: nil).where("esi_items_exception->>'m' LIKE '(403)%'")
      contracts.update_all(esi_items_exception: nil)

      args = contracts.map { |c| [c.id] }
      Contract::SyncItemsFromESIWorker.perform_bulk(args)
    end
  end

  task backfill_locations: :environment do
    records = [Constellation, Region, SolarSystem, Station, Structure].each_with_object([]) do |locatable_type, a|
      locatable_type.pluck(:id, :name).each do |locatable_id, name|
        a << { locatable_id: locatable_id, locatable_type: locatable_type.name, name: name }
      end
    end

    Location.import!(records, on_duplicate_key_update: { conflict_target: %i[locatable_id locatable_type], columns: :all })
  end
end
