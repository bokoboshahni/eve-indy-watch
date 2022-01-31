# frozen_string_literal: true

module SystemHelpers
  def log_in(user_id)
    visit test_login_path
    fill_in 'User ID', with: user_id
    click_button 'Log in'

    expect(page).to have_text('Dashboard')
  end
end
