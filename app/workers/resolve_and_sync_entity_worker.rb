class ResolveAndSyncEntityWorker < ApplicationWorker
  sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: :log

  def perform(id)
    ResolveAndSyncEntity.call(id)
  end
end
