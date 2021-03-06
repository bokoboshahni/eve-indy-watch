# frozen_string_literal: true

class ResolveAndSyncEntityWorker < ApplicationWorker
  sidekiq_options lock: :until_and_while_executing, on_conflict: :log

  def perform(id)
    ResolveAndSyncEntity.call(id)
  end
end
