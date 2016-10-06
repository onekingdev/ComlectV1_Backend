# frozen_string_literal: true
module SessionsHelper
  def sign_in(user, password = 'password')
    post user_session_path, 'user[email]' => user.email, 'user[password]' => password
    assert_response 302
  end
end
