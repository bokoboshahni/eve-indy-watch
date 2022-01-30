# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Homepage', type: :request do
  describe 'GET /' do
    context 'when logged in' do
      let(:current_user) { create(:user) }

      before { log_in(current_user) }

      it 'redirects to the dashboard' do
        expect(get(root_path)).to redirect_to(dashboard_path)
      end
    end

    context 'when logged out' do
      it 'renders the landing page' do
        expect(get(root_path)).to render_template(:index)
      end
    end
  end
end
