# frozen_string_literal: true

class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]

  def create
    user = User.find_first_by_auth_conditions(email: params[:user][:email])

    respond_with(errors: 'Please, confirm your email') && return unless user.email_confirmed

    if user&.valid_password?(params[:user][:password])
      unless params[:otp_secret]
        user.email_otp
        render(json: { message: 'You have received one time passcode on your email to verify login' }) && return
      end
      if user.verify_otp(params[:otp_secret])
        render json: { token: JsonWebToken.encode(sub: user.id) }
      else
        render json: { errors: { invalid: 'Invalid secret key' } }, status: :unprocessable_entity
      end
    else
      render json: { errors:
                    { invalid: I18n.t('devise.failure.invalid', authentication_keys: 'email') } }, status: :unprocessable_entity
    end
  end
end
