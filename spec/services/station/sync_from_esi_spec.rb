# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Station::SyncFromESI, type: :service, vcr: { allow_playback_repeats: true } do
  subject(:sync_from_esi) { described_class }

  let(:locations_reader) { Kredis.redis(config: :locations_reader) }
  let(:station_id) { 60_003_760 } # Jita IV - Moon 4 - Caldari Navy Assembly Plant

  before do
    Category.create!(id: 3, name: 'Station', published: true)
    Group.create!(id: 15, name: 'Station', published: true, category_id: 3)
    Type.create!(id: 52_678, name: 'Jita Trade Hub', group_id: 15)
    Region.create!(id: 10_000_002, name: 'The Forge')
    Constellation.create!(id: 20_000_020, region_id: 10_000_002, name: 'Kimotoro')
    SolarSystem.create!(id: 30_000_142, constellation_id: 20_000_020, name: 'The Forge', security: 0.9459131166648389)
  end

  context 'when the station has not been synced' do
    let(:station) { sync_from_esi.call(station_id) }

    it 'returns the station' do
      expect(station).to be_persisted
    end

    it "syncs the station's corporation" do
      expect(station.owner).to be_persisted
    end

    it 'creates a Location for the Station' do
      expect(station.location).to be_persisted
    end

    it "caches the station's expiry" do
      sync_from_esi.call(station_id)
      expect(locations_reader.get("locations.#{station_id}.esi_expires")).to eq(station.esi_expires_at.to_s(:number))
    end

    it "caches the station's last modified time" do
      sync_from_esi.call(station_id)
      expect(locations_reader.get("locations.#{station_id}.esi_last_modified")).to eq(station.esi_last_modified_at.to_s(:number))
    end
  end

  context 'when the station has been synced and is not expired' do
    it 'does not call ESI to update the station' do
      sync_from_esi.call(station_id)

      expect(a_request(:any, 'esi.evetech.net')).not_to have_been_made
      sync_from_esi.call(station_id)
    end

    it 'returns the station' do
      sync_from_esi.call(station_id)

      expect(sync_from_esi.call(station_id)).to be_persisted
    end
  end
end
