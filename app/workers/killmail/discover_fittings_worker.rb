# frozen_string_literal: true

class Killmail < ApplicationRecord
  class DiscoverFittingsWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(killmail_id)
      killmail = Killmail.find(killmail_id)
      killmail.discover_fittings!
    end
  end
end
