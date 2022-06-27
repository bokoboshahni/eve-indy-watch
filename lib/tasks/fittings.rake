# frozen_string_literal: true

namespace :fittings do
  task import_eft_files: :environment do
    owner_type = ENV.fetch('OWNER_TYPE', 'Alliance')
    owner_id = ENV.fetch('OWNER_ID', Rails.application.config.x.app.main_alliance_id)
    owner = Object.const_get(owner_type).find(owner_id)
    dir = ENV.fetch('DIR', Rails.root.join('tmp/fittings'))
    paths = Dir[File.join(dir, '*.txt')]
    paths.each do |path|
      Fitting::ImportFromEFTFile.call(path, owner:)
    end

    puts "Imported #{paths.count} fitting(s) from #{dir}"

    args = owner.assigned_contracts
                .where(type: 'item_exchange')
                .where.not(esi_items_last_modified_at: nil)
                .pluck(:id)
                .map { |id| [id] }
    Sidekiq::Client.push_bulk('class' => 'Contract::DiscoverFittingsWorker', 'args' => args)

    puts "Queued #{args.count} contract(s) assigned to #{owner.name} for fitting discovery"
  end
end
