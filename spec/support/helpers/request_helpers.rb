# frozen_string_literal: true

module RequestHelpers
  def log_in(user)
    post(test_login_path(user_id: user.id))
  end

  def log_out
    delete(test_login_path)
  end
end
