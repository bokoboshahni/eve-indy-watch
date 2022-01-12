# frozen_string_literal: true

class Alliance < ApplicationRecord
  class FetchAllKillmailsFromZKBWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform
      Alliance.where(zkb_sync_enabled: true).each(&:fetch_killmails_from_zkb_async)
    end
  end
end
