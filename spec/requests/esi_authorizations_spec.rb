# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ESIAuthorizations', type: :request do
  let(:current_user) { create(:admin_user) }

  describe 'POST /settings/authorizations' do
    before do
      post test_login_path(user_id: current_user.id)
    end

    it 'redirects to ESI' do
      expect(post(settings_esi_authorizations_path)).to redirect_to(%r{\Ahttps://login.eveonline.com/v2/oauth/authorize})
    end
  end
end
