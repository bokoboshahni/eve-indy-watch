# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ESIAuthorizations', type: :request do
  let(:current_user) { create(:admin_user) }

  before { log_in(current_user) }

  describe 'POST /settings/authorizations' do
    it 'redirects to ESI' do
      expect(post(settings_esi_authorizations_path)).to redirect_to(%r{\Ahttps://login.eveonline.com/v2/oauth/authorize})
    end
  end
end
