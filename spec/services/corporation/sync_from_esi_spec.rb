# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Corporation::SyncFromESI, type: :service, vcr: { allow_playback_repeats: true } do
  subject(:sync_from_esi) { described_class }

  let(:corporation_id) { 98_169_165 } # Brave Newbies Inc.

  context 'when the corporation has not been synced' do
    let(:corporation) { described_class.call(corporation_id) }

    it 'returns the corporation' do
      expect(corporation).to be_persisted
    end
  end

  context 'when the corporation has been synced and is not expired' do
    it 'does not call ESI to update the corporation' do
      described_class.call(corporation_id)

      expect(a_request(:any, 'esi.evetech.net')).not_to have_been_made
      described_class.call(corporation_id)
    end

    it 'returns the corporation' do
      described_class.call(corporation_id)

      expect(described_class.call(corporation_id)).to be_persisted
    end
  end
end
