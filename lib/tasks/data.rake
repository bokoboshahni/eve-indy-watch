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
end
