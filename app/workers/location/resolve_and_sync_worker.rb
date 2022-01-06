# frozen_string_literal: true

class Location < ApplicationRecord
  class ResolveAndSyncWorker < ApplicationWorker
    sidekiq_options lock: :until_executed

    def perform(id, authorization_id)
      authorization = ESIAuthorization.find(authorization_id)
      Location::ResolveAndSync.call(id, authorization)
    end
  end
end
