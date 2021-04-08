# frozen_string_literal: true

class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_first_by_auth_conditions(email: params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      render json: { token: JsonWebToken.encode(sub: user.id) }
    else
      render json: { errors:
                    { invalid: I18n.t('devise.failure.invalid', authentication_keys: 'email') } }, status: :unprocessable_entity
    end
  end
end
