# frozen_string_literal: true

class Corporation < ApplicationRecord
  class FetchContractsFromESI < ApplicationService
    def initialize(corporation)
      super

      @corporation = corporation
    end

    def call # rubocop:disable Metrics/AbcSize
      unless corporation.esi_contracts_expired?
        debug("#{corporation.log_name} contracts do not expire until #{corporation.esi_contracts_expires_at}")
        return []
      end

      esi_authorize!(corporation.esi_authorization)
      auth = { Authorization: "Bearer #{corporation.esi_authorization.access_token}" }
      resps = esi.get_corporation_contracts_raw(corporation_id: corporation_id, headers: auth)
      first_resp = resps.first
      expires = DateTime.parse(first_resp.headers['expires'])
      last_modified = DateTime.parse(first_resp.headers['last-modified'])
      data = resps.map(&:json).reduce([], :concat)

      debug("Fetched #{data.count} contract(s) for #{corporation.log_name}")

      [expires, last_modified, data]
    end

    private

    attr_reader :corporation

    delegate :id, :name, to: :corporation, prefix: true
  end
end
