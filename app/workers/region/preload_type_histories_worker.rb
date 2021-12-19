class Region < ApplicationRecord
  class PreloadTypeHistoriesWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform
      args = Region.where(type_history_preload_enabled: true).each_with_object([]) do |region, a|
        type_ids = FittingItem.distinct(:type_id).pluck(:type_id)
        type_ids += ContractItem.distinct(:type_id).pluck(:type_id)
        type_ids += KillmailItem.distinct(:type_id).pluck(:type_id)
        type_ids.uniq!

        a.push(*type_ids.map { |type_id| [region.id, type_id] })
      end
      ImportTypeHistoryWorker.perform_bulk(args)
    end
  end
end
