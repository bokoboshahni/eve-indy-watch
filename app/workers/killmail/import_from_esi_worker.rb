# frozen_string_literal: true

class Killmail < ApplicationRecord
  class ImportFromESIWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log
    # sidekiq_throttle concurrency: { limit: 8 }

    def perform(data)
      data = Oj.load(data)
      killmail = Killmail.import_from_esi!(data)
      killmail.discover_fittings!
    end
  end
end
