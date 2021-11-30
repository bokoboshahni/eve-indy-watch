# frozen_string_literal: true

class Corporation < ApplicationRecord
  class SyncContractsFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(corporation_id)
      super

      @corporation = Corporation.find(corporation_id)
    end

    def call # rubocop:disable Metrics/AbcSize
      unless corporation.contract_sync_enabled
        warn "#{corporation_name} (#{corporation_id}) does not have contract sync enabled"
      end

      if corporation.esi_contracts_expires_at&.>= Time.zone.now
        logger.debug("ESI response for corporation contracts (#{corporation.name}) #{corporation.id} is not expired: #{corporation.esi_contracts_expires_at.iso8601}") # rubocop:disable Metrics/LineLength
        return []
      end

      esi_authorize!(corporation.esi_authorization)
      auth = { Authorization: "Bearer #{corporation.esi_authorization.access_token}" }
      resps = esi.get_corporation_contracts_raw(corporation_id: corporation_id, headers: auth)
      first_resp = resps.first
      expires = DateTime.parse(first_resp.headers['expires'])
      last_modified = DateTime.parse(first_resp.headers['last-modified'])
      data = resps.map(&:json).reduce([], :concat)
      debug("Fetched #{data.count} contract(s) for corporation #{corporation.name} (#{corporation.id})")

      contracts = []
      corporation.transaction do
        related_ids = data.each_with_object(Set.new) do |contract, s|
          %w[acceptor_id assignee_id issuer_id issuer_corporation_id].each { |k| s.add(contract[k]) if contract[k] }
        end

        related = {}
        workers = []
        related_ids.to_a.compact.in_groups(16, false) do |batch|
          workers << Thread.new do
            batch.each do |id|
              related[id] = find_and_sync_entity(id)
            end
          end
        end
        workers.each(&:join)

        debug("Synced related #{related.values.select do |r|
                                  r.is_a?(Character)
                                end.count} character(s) from #{data.count} contract(s)")
        debug("Synced related #{related.values.select do |r|
                                  r.is_a?(Corporation)
                                end.count} corporation(s) from #{data.count} contract(s)")
        debug("Synced related #{related.values.select do |r|
                                  r.is_a?(Alliance)
                                end.count} alliance(s) from #{data.count} contract(s)")

        location_ids = data.each_with_object(Set.new) do |contract, s|
          %w[start_location_id end_location_id].each { |k| s.add(contract[k]) if contract[k] }
        end

        locations = {}
        workers = []
        location_ids.to_a.compact.in_groups(16, false) do |batch|
          workers << Thread.new do
            batch.each do |id|
              locations[id] = find_and_sync_location(id)
            end
          end
        end
        workers.each(&:join)
        debug("Synced #{location_ids.count} related location(s) from #{data.count} contract(s)")

        workers = []
        data.in_groups(16, false) do |batch|
          workers << Thread.new do
            batch.each do |contract_data|
              Contract.transaction do
                contract = map_contract(contract_data, related, locations, last_modified, expires)

                record = Contract.find_or_initialize_by(id: contract[:id])
                record.attributes = contract

                event_attrs = { corporation_id: record.issuer_corporation_id, price: record.price,
                                reward: record.reward, collateral: record.collateral }
                event_attrs[:alliance_id] = record.assignee_id if record.assignee_type == 'Alliance'
                events = []

                if record.new_record? && %w[in_progress finished finished_contractor finished_issuer
                                            outstanding].include?(record.status)
                  case record.status
                  when 'in_progress'
                    events << { event: 'in_progress', time: record.accepted_at }
                  when 'finished_issuer', 'finished_contractor', 'finished'
                    events << { event: 'finished', time: record.completed_at }
                  when 'outstanding'
                    events << { event: 'issued', time: record.issued_at }
                  end
                elsif record.status_changed?
                  case record.status
                  when 'in_progress'
                    events << { event: 'in_progress', time: record.accepted_at }
                  when 'finished_issuer', 'finished_contractor', 'finished'
                    events << { event: 'finished', time: record.completed_at }
                  end
                end

                if record.expired_at <= Time.zone.now && record.status == 'outstanding' && (record.new_record? || (record.persisted? && !record.events.exists?(event: 'expired')))
                  events << { event: 'expired', time: record.expired_at }
                end

                record.save!
                events.each { |event| record.events.create!(event_attrs.merge(event)) }
                contracts << record
              end
            end
          end
        end
        workers.each(&:join)

        corporation.update!(esi_contracts_expires_at: expires, esi_contracts_last_modified_at: last_modified)

        debug("Synced #{contracts.count} contracts for corporation #{corporation_name} (#{corporation_id}) from ESI")
      end

      contracts
    rescue ESI::Errors::ClientError => e
      msg = "Unable to sync corporation contracts #{corporation_id} from ESI: #{e.message}"
      raise Error, msg, cause: e
    end

    private

    attr_reader :corporation

    delegate :id, :name, to: :corporation, prefix: true

    def map_contract(data, related, locations, last_modified, expires)
      acceptor = related[data['acceptor_id']]
      assignee = related[data['assignee_id']]
      end_location = locations[data['end_location_id']]
      start_location = locations[data['start_location_id']]

      {
        accepted_at: data['date_accepted'],
        acceptor_id: acceptor&.id,
        acceptor_type: acceptor&.class&.name,
        assignee_id: assignee&.id,
        assignee_type: assignee&.class&.name,
        availability: data['availability'],
        buyout: data['buyout'],
        collateral: data['collateral'],
        completed_at: data['date_completed'],
        days_to_complete: data['days_to_complete'],
        end_location_id: end_location&.id,
        end_location_type: end_location&.class&.name,
        esi_expires_at: expires,
        esi_last_modified_at: last_modified,
        expired_at: data['date_expired'],
        for_corporation: data['for_corporation'],
        id: data['contract_id'],
        issued_at: data['date_issued'],
        issuer_corporation_id: data['issuer_corporation_id'],
        issuer_id: data['issuer_id'],
        price: data['price'],
        reward: data['reward'],
        start_location_id: start_location&.id,
        start_location_type: start_location&.class&.name,
        status: data['status'],
        title: data['title'],
        type: data['type'],
        volume: data['volume']
      }
    end

    def find_and_sync_entity(id)
      Retriable.retriable on: [Character::SyncFromESI::Error, Corporation::SyncFromESI::Error,
                               Alliance::SyncFromESI::Error] do
        case id
        when 0
          nil
        when 90_000_000..97_999_999
          Character::SyncFromESI.call(id)
        when 1_000_000..2_000_000, 98_000_000..98_999_999
          Corporation::SyncFromESI.call(id)
        when 99_000_000..99_999_999
          Alliance::SyncFromESI.call(id)
        when 100_000_000..2_099_999_999
          begin
            Character::SyncFromESI.call(id)
          rescue Character::SyncFromESI::Error => e
            if e.cause.is_a?(ESI::Errors::NotFoundError)
              begin
                Corporation::SyncFromESI.call(id)
              rescue Corporation::SyncFromESI::Error => e
                Alliance::SyncFromESI.call(id) if e.cause_is_a?(ESI::Errors::NotFoundError)
              end
            end
          end
        else
          Character::SyncFromESI.call(id)
        end
      end
    end

    def find_and_sync_location(id)
      case id
      when 60_000_000..64_000_000
        begin
          Station.find(id)
        rescue ActiveRecord::RecordNotFound
          Station::SyncFromESI.call(id)
        end
      else
        Structure::SyncFromESI.call(id, corporation.esi_authorization)
      end
    end
  end
end
