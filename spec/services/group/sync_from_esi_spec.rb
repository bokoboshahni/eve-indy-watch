# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group::SyncFromESI, type: :service, vcr: { allow_playback_repeats: true } do
  subject(:sync_from_esi) { described_class }

  before do
    Category.create!(id: 17, name: 'Commodity', published: true)
  end

  let(:group_id) { 4165 } # Peculiar Materials

  context 'when the group has not been synced' do
    let(:group) { sync_from_esi.call(group_id) }

    it 'returns the group' do
      expect(group).to be_persisted
    end
  end

  context 'when the group has been synced and is not expired' do
    it 'does not call ESI to update the group' do
      sync_from_esi.call(group_id)

      expect(a_request(:any, 'esi.evetech.net')).not_to have_been_made
      sync_from_esi.call(group_id)
    end

    it 'returns the group' do
      sync_from_esi.call(group_id)

      expect(sync_from_esi.call(group_id)).to be_persisted
    end
  end
end
