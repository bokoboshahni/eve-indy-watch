class ResolveAndSyncLocationWorker < ApplicationWorker
  sidekiq_options retry: 5, lock: :until_and_while_executing, on_conflict: :log

  def perform(id, authorization_id)
    authorization = ESIAuthorization.find(authorization_id)
    ResolveAndSyncLocation.call(id, authorization)
  end
end
