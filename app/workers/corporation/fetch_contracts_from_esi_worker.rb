# frozen_string_literal: true

class Corporation < ApplicationRecord
  class FetchContractsFromESIWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(corporation_id)
      corporation = Corporation.find(corporation_id)
      expires, last_modified, data = corporation.fetch_contracts_from_esi

      if data && data.count.positive?
        args = data.map { |c| [corporation_id, c.merge(esi_expires_at: expires, esi_last_modified_at: last_modified).to_json] }
        Sidekiq::Client.push_bulk('class' => 'Contract::SyncFromESIWorker', 'args' => args)
      end

      corporation.update!(
        esi_contracts_expires_at: expires,
        esi_contracts_last_modified_at: last_modified
      )
    end
  end
end
