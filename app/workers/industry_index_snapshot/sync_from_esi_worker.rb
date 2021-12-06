# frozen_string_literal: true

class IndustryIndexSnapshot < ApplicationRecord
  class SyncFromESIWorker < ApplicationWorker
    sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: :log

    def perform
      IndustryIndexSnapshot.sync_from_esi!
    end
  end
end
