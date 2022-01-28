# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Type::SyncFromESI, type: :service, vcr: { allow_playback_repeats: true } do
  subject(:sync_from_esi) { described_class }

  before do
    Category.create!(id: 17, name: 'Commodity', published: true)
    Group.create!(id: 4165, name: 'Peculiar Materials', category_id: 17, published: true)
    MarketGroup.create!(id: 2013, name: 'Unknown Components', description: 'Mysterious pieces of technology of unknown origin')
  end

  let(:type_id) { 62_032 } # Time Crystal Oscillator

  context 'when the type has not been synced' do
    let(:type) { sync_from_esi.call(type_id) }

    it 'returns the type' do
      expect(type).to be_persisted
    end
  end

  context 'when the type and group have not been synced' do
    before { Group.destroy_all }

    let(:type) { sync_from_esi.call(type_id) }

    it 'returns the type' do
      expect(type).to be_persisted
    end

    it 'syncs the group' do
      expect(type.group).to be_persisted
    end
  end

  context 'when the type has been synced and is not expired' do
    it 'does not call ESI to update the type' do
      sync_from_esi.call(type_id)

      expect(a_request(:any, 'esi.evetech.net')).not_to have_been_made
      sync_from_esi.call(type_id)
    end

    it 'returns the type' do
      sync_from_esi.call(type_id)

      expect(described_class.call(type_id)).to be_persisted
    end
  end
end
