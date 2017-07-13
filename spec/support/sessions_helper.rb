# frozen_string_literal: true

module SessionsHelper
  def sign_in(user, password = 'password')
    post user_session_path, 'user[email]' => user.email, 'user[password]' => password
    expect(response).to have_http_status(:found)
  end

  def sign_out
    delete destroy_user_session_path
    expect(response).to have_http_status(:found)
  end
end
