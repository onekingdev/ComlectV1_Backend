# frozen_string_literal: true

module SessionsHelper
  def sign_in(user, password = 'password')
    post user_session_path, params: { 'user[email]' => user.email, 'user[password]' => password }
    assert_response 302
  end

  def sign_out
    delete destroy_user_session_path
    assert_response 302
  end
end
