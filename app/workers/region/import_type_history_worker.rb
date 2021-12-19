class Region < ApplicationRecord
  class ImportTypeHistoryWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(region_id, type_id)
      type = Type.find(type_id)
      Region.find(region_id).import_type_history!(type)
    end
  end
end
