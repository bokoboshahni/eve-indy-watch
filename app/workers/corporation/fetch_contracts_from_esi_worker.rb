# frozen_string_literal: true

class Corporation < ApplicationRecord
  class FetchContractsFromESIWorker < ApplicationWorker
    sidekiq_options lock: :until_executing, on_conflict: :log

    def perform(corporation_id)
      corporation = Corporation.find(corporation_id)
      expires, last_modified, data = corporation.fetch_contracts_from_esi

      if data&.count&.positive?
        finished_contract_ids = Contract.select(:id)
                                        .where(id: data.map { |c| c['contract_id'] })
                                        .where(status: %w[deleted finished])
                                        .pluck(:id)

        args = data.reject { |c| finished_contract_ids.include?(c['contract_id']) }.map do |c|
          [corporation_id, c.merge(esi_expires_at: expires, esi_last_modified_at: last_modified).to_json]
        end
        Sidekiq::Client.push_bulk('class' => 'Contract::SyncFromESIWorker', 'args' => args)
      end

      corporation.update!(
        esi_contracts_expires_at: expires,
        esi_contracts_last_modified_at: last_modified
      )
    end
  end
end
