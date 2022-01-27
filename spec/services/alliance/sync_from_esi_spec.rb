# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Alliance::SyncFromESI, type: :service, vcr: { allow_playback_repeats: true } do
  subject(:sync_from_esi) { described_class }

  let(:alliance_id) { 99_003_214 } # Brave Collective

  context 'when the alliance has not been synced' do
    let(:alliance) { described_class.call(alliance_id) }

    it 'returns the alliance' do
      expect(alliance).to be_persisted
    end
  end

  context 'when the alliance has been synced and is not expired' do
    it 'does not call ESI to update the alliance' do
      described_class.call(alliance_id)

      expect(a_request(:any, 'esi.evetech.net')).not_to have_been_made
      described_class.call(alliance_id)
    end

    it 'returns the alliance' do
      described_class.call(alliance_id)

      expect(described_class.call(alliance_id)).to be_persisted
    end
  end
end
