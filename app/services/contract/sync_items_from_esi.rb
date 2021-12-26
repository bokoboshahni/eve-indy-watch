# frozen_string_literal: true

require 'json/add/exception'

class Contract < ApplicationRecord
  class SyncItemsFromESI < ApplicationService
    include ESIHelpers

    class Error < RuntimeError; end

    def initialize(contract)
      super

      @contract = contract
      @corporation = contract.assignee.api_corporation
    end

    def call # rubocop:disable Metrics/AbcSize
      if contract.esi_items_synced?
        debug("Items have already been fetched for contract #{contract_id}")
        return
      end

      if contract.esi_items_unavailable?
        debug("Items are not available in ESI for contract #{contract_id}")
        return
      end

      if contract.esi_items_inaccessible?
        debug("Items are not accessible in ESI for contract #{contract_id}")
        return
      end

      if contract.esi_items_rate_limited?
        debug('Last request for items was rate limited, waiting 10s')
        sleep 10
      end

      if contract.courier?
        debug('Items are not available for courier contracts')
        return
      end

      authorization = find_authorization
      raise Error, "Unable to find authorization for contract #{contract_id}" unless authorization

      esi_retriable do
        esi_authorize!(authorization)
        auth = { Authorization: "Bearer #{authorization.access_token}" }
        resp = esi.get_corporation_contract_items_raw(corporation_id: corporation_id, contract_id: contract_id,
                                                      headers: auth)
        expires = resp.headers['expires']
        last_modified = resp.headers['last-modified']
        data = resp.json

        items = data.map do |item|
          item[:id] = item.delete('record_id')
          item.merge(contract_id: contract_id)
        end

        contract.transaction do
          ContractItem.import!(items, track_validation_failures: true,
                                      on_duplicate_key_update: { conflict_target: %i[id], columns: :all })
          contract.update!(esi_items_expires_at: expires, esi_items_last_modified_at: last_modified,
                           esi_items_exception: nil)
        end

        debug("Synced #{items.count} items for contract #{contract_id} from ESI")
      end
    rescue ESI::Errors::NotFoundError, ESI::Errors::ForbiddenError => e
      contract.update!(esi_items_exception: e.as_json)
      error "Unable to fetch items for contract #{contract_id}, see #esi_items_exception on contract for details: #{e.message}"
    end

    private

    attr_reader :contract, :corporation

    delegate :assignee, :id, to: :contract, prefix: true
    delegate :id, to: :corporation, prefix: true

    def find_authorization
      return corporation.esi_authorization if corporation.esi_authorization

      return contract_assignee.esi_authorization if contract_assignee.respond_to?(:esi_authorization)

      return contract_assignee.corporation.esi_authorization if contract_assignee.corporation.esi_authorization

      contract_assignee.alliance.esi_authorization if contract_assignee.alliance&.esi_authorization
    end
  end
end
