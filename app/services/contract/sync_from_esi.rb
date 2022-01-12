# frozen_string_literal: true

class Contract < ApplicationRecord
  class SyncFromESI < ApplicationService
    def initialize(corporation, data)
      super

      @corporation = corporation
      @data = data
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      contract_id = data['contract_id']
      record = Contract.find_or_initialize_by(id: contract_id)

      if record.persisted? && record.done?
        debug "Contract #{contract_id} is already done"
        return record
      end

      corporation.transaction do # rubocop:disable Metrics/BlockLength
        entity_keys = %w[acceptor_id assignee_id issuer_id issuer_corporation_id]
        entity_ids = entity_keys.each_with_object(Set.new) { |k, s| s.add(data[k]) if data[k] }
        entities = entity_ids.index_with { |id| find_and_sync_entity(id) }

        location_keys = %w[start_location_id end_location_id]
        location_ids = location_keys.each_with_object(Set.new) { |k, s| s.add(data[k]) if data[k] }
        locations = location_ids.index_with { |id| find_and_sync_location(id) }

        contract = map_contract(data, entities, locations)
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

        debug("Synced contract #{record.id} for #{corporation_name}")

        record
      end
    end

    private

    attr_reader :corporation, :data

    delegate :id, :name, to: :corporation, prefix: true

    def map_contract(data, entities, locations) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      acceptor = entities[data['acceptor_id']]
      assignee = entities[data['assignee_id']]
      end_location = locations[data['end_location_id']]
      start_location = locations[data['start_location_id']]

      {
        accepted_at: data['date_accepted'],
        acceptor_id: acceptor&.id,
        acceptor_name: acceptor&.name,
        acceptor_type: acceptor&.class&.name,
        assignee_id: assignee&.id,
        assignee_name: assignee&.name,
        assignee_type: assignee&.class&.name,
        availability: data['availability'],
        buyout: data['buyout'],
        collateral: data['collateral'],
        completed_at: data['date_completed'],
        days_to_complete: data['days_to_complete'],
        end_location_id: end_location&.id,
        end_location_type: end_location&.class&.name,
        end_location_name: end_location&.name,
        esi_expires_at: data['esi_expires_at'],
        esi_last_modified_at: data['esi_last_modified_at'],
        expired_at: data['date_expired'],
        for_corporation: data['for_corporation'],
        id: data['contract_id'],
        issued_at: data['date_issued'],
        issuer_corporation_id: data['issuer_corporation_id'],
        issuer_id: data['issuer_id'],
        price: data['price'],
        reward: data['reward'],
        start_location_id: start_location&.id,
        start_location_name: start_location&.name,
        start_location_type: start_location&.class&.name,
        status: data['status'],
        title: data['title'],
        type: data['type'],
        volume: data['volume']
      }
    end

    def find_and_sync_entity(id) # rubocop:disable Metrics/MethodLength
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
                Alliance::SyncFromESI.call(id) if e.cause.is_a?(ESI::Errors::NotFoundError)
              end
            end
          end
        else
          Character::SyncFromESI.call(id)
        end
      end
    end

    def find_and_sync_location(id)
      Location::ResolveAndSync.call(id, corporation.esi_authorization)
    end
  end
end
