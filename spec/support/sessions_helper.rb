# frozen_string_literal: true

module SessionsHelper
  def sign_in(user, password = 'password')
    post sign_in_api_users_path, params: { 'user[email]' => user.email, 'user[password]' => password }
    expect(response).to have_http_status(:ok)
  end

  def sign_out
    delete destroy_user_session_path
    expect(response).to have_http_status(:found)
  end

  def authenticated_header(user)
    token = JsonWebToken.encode(sub: user.id, jwt_hash: user.jwt_hash)
    { 'Authorization': token }
  end
end
