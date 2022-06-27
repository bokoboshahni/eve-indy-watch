# frozen_string_literal: true

class Alliance < ApplicationRecord
  class FetchKillmailsFromZKBWorker < ApplicationWorker
    sidekiq_options lock: :until_and_while_executing, on_conflict: :log

    def perform(alliance_id, year = nil, month = nil)
      alliance = Alliance.find(alliance_id)
      data = alliance.fetch_killmails_from_zkb(year:, month:)

      if data&.count&.positive?
        args = data.reject { |k| Killmail.exists?(k['killmail_id']) }.map { |k| [k.to_json] }
        Sidekiq::Client.push_bulk('class' => 'Killmail::ImportFromESIWorker', 'args' => args)
      end

      alliance.update!(zkb_fetched_at: Time.zone.now)
    end
  end
end
