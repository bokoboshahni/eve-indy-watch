# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Character::SyncFromESI, type: :service, vcr: { allow_playback_repeats: true } do
  subject(:sync_from_esi) { described_class }

  let(:character_id) { 2_113_024_536 } # Bokobo Shahni

  context 'when the character has not been synced' do
    let(:character) { described_class.call(character_id) }

    it 'returns the character' do
      expect(character).to be_persisted
    end

    it "syncs the character's alliance" do
      expect(character.alliance).to be_persisted
    end

    it "syncs the character's corporation" do
      expect(character.corporation).to be_persisted
    end
  end

  context 'when the character has been synced and is not expired' do
    it 'does not call ESI to update the character' do
      described_class.call(character_id)

      expect(a_request(:any, 'esi.evetech.net')).not_to have_been_made
      described_class.call(character_id)
    end

    it 'returns the character' do
      described_class.call(character_id)

      expect(described_class.call(character_id)).to be_persisted
    end
  end
end
