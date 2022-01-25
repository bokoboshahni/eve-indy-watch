# frozen_string_literal: true

class Killmail < ApplicationRecord
  class ImportFromESI < ApplicationService
    def initialize(zkb_data)
      super

      @zkb_data = zkb_data
    end

    def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      killmail_hash = zkb_data['zkb']['hash']
      killmail_id = zkb_data['killmail_id']

      killmail_record = Killmail.find_by(id: killmail_id)
      if killmail_record
        debug("Killmail #{killmail_id} already exists")
        return killmail_record
      end

      esi_data = esi.get_killmail(killmail_hash: killmail_hash, killmail_id: killmail_id)

      victim = esi_data['victim']
      attackers = esi_data['attackers'].map { |a| a.merge(killmail_id: killmail_id) }

      killmail = {
        id: killmail_id,
        killmail_hash: killmail_hash,
        awox: zkb_data['zkb']['awox'],
        solo: zkb_data['zkb']['solo'],
        npc: zkb_data['zkb']['npc'],
        points: zkb_data['zkb']['points'],
        zkb_total_value: zkb_data['zkb']['totalValue'],
        zkb_dropped_value: zkb_data['zkb']['droppedValue'],
        zkb_destroyed_value: zkb_data['zkb']['destroyedValue'],
        position_x: victim['position']['x'],
        position_y: victim['position']['y'],
        position_z: victim['position']['z'],
        time: esi_data['killmail_time'],
        alliance_id: victim['alliance_id'],
        corporation_id: victim['corporation_id'],
        faction_id: victim['faction_id'],
        moon_id: esi_data['moon_id'],
        ship_type_id: victim['ship_type_id'],
        solar_system_id: esi_data['solar_system_id'],
        war_id: esi_data['war_id'],
        damage_taken: victim['damage_taken'],
        attackers_attributes: attackers
      }

      alliance_ids = Set.new
      corporation_ids = Set.new
      character_ids = Set.new

      alliance_ids.add(killmail['alliance_id']) if killmail['alliance_id']
      corporation_ids.add(killmail['corporation_id']) if killmail['corporation_id']
      character_ids.add(killmail['character_id']) if killmail['character_id']

      attackers.each do |a|
        Type::SyncFromESI.call(a['ship_type_id'], ignore_not_found: true) unless Type.exists?(a['ship_type_id'])
        Type::SyncFromESI.call(a['weapon_type_id'], ignore_not_found: true) unless Type.exists?(a['weapon_type_id'])

        alliance_ids.add(a['alliance_id']) if a['alliance_id']
        corporation_ids.add(a['corporation_id']) if a['corporation_id']
        character_ids.add(a['character_id']) if a['character_id']
      end

      Alliance.transaction { alliance_ids.each { |i| Alliance::SyncFromESI.call(i) } }
      Corporation.transaction { corporation_ids.each { |i| Corporation::SyncFromESI.call(i) } }
      Character.transaction { character_ids.each { |i| Character::SyncFromESI.call(i) } }
      Killmail.transaction do # rubocop:disable Metrics/BlockLength
        ship_type_id = killmail['ship_type_id']
        Type::SyncFromESI.call(ship_type_id, ignore_not_found: true) unless Type.exists?(ship_type_id)

        record = Killmail.create!(killmail)

        Array(victim['items']).each do |item_data|
          type_id = item_data['item_type_id']
          Type::SyncFromESI.call(type_id, ignore_not_found: true) unless Type.exists?(type_id)

          item = record.items.create!(
            flag_id: item_data['flag'],
            quantity_destroyed: item_data['quantity_destroyed'],
            quantity_dropped: item_data['quantity_dropped'],
            singleton: item_data['singleton'],
            type_id: item_data['item_type_id']
          )

          Array(item['items']).each do |item_data|
            type_id = item_data['item_type_id']
            Type::SyncFromESI.call(type_id, ignore_not_found: true) unless Type.exists?(type_id)

            record.items.create!(
              flag_id: item_data['flag'],
              quantity_destroyed: item_data['quantity_destroyed'],
              quantity_dropped: item_data['quantity_dropped'],
              singleton: item_data['singleton'],
              type_id: item_data['item_type_id'],
              parent: item
            )
          end
        end

        record
      end
    end

    private

    attr_reader :zkb_data
  end
end
