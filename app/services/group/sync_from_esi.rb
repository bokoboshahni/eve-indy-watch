# frozen_string_literal: true

class Group < ApplicationRecord
  class SyncFromESI < ApplicationService
    def initialize(group_id, ignore_not_found: false)
      super

      @group_id = group_id
      @ignore_not_found = ignore_not_found
    end

    def call
      group = Group.find_by(id: group_id)

      if group&.esi_expires_at&.>= Time.zone.now
        logger.debug("ESI response for group (#{group.name}) #{group.id} is not expired: #{group.esi_expires_at.iso8601}")
        return group
      end

      group_attrs = group_attrs_from_esi
      group ? group.update!(group_attrs) : group = Group.create!(group_attrs.merge(id: group_id))

      debug("Synced group #{group_id} from ESI")
      group
    end

    private

    attr_reader :group_id, :ignore_not_found

    def group_attrs_from_esi
      resp = esi.get_universe_group_raw(group_id:)
      expires = DateTime.parse(resp.headers['expires'])
      last_modified = DateTime.parse(resp.headers['last-modified'])
      data = Oj.load(resp.body)

      {
        esi_expires_at: expires,
        esi_last_modified_at: last_modified,
        id: group_id,
        name: data['name'],
        category_id: data['category_id'],
        published: data['published']
      }
    end
  end
end
