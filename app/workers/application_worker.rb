# frozen_string_literal: true

class ApplicationWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  include WorkerHelpers

  def cancelled?
    Sidekiq.redis { |c| c.exists?("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis { |c| c.setex("cancelled-#{jid}", 86_400, 1) }
  end
end
