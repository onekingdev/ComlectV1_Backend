# frozen_string_literal: true

class Api::OtpSecretsController < ApiController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_first_by_auth_conditions(email: params[:user][:email])

    user.email_otp
    render(json: { message: I18n.t('api.otp_secrets.otp_sent') })
  end
end
