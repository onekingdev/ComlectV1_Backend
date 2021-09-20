# frozen_string_literal: true

class Api::Settings::EmailController < ApiController
  skip_before_action :verify_authenticity_token

  def create
    if current_user.update(email: email_params[:email])
      respond_with status: :ok
    else
      respond_with errors: current_user.errors, status: :error
    end
  end

  def verify_change_email
    user = User.find_by(email: params[:user][:email])
    if user
      respond_with(
        errors: { not_found: 'Email is used for other account!' },
        status: :unprocessable_entity
      ) and return
    end

    current_user.email_otp
    respond_with(
      email: current_user.email,
      message: I18n.t('api.authentication.otp_sent'),
      status: :ok
    ) and return
  end

  def update_login_email
    if current_user.verify_otp(params[:otp_secret])
      current_user.skip_reconfirmation!
      if current_user.update(email: params[:new_email])
        respond_with status: :ok
      else
        respond_with errors: current_user.errors, status: :error
      end
    else
      render json: { errors: { invalid: I18n.t('api.authentication.invalid_otp') } }, status: :unprocessable_entity
    end
  end

  def update
    if User.confirm_by_token(email_params[:confirmation_token])
      respond_with status: :ok
    else
      respond_with errors: current_user.errors, status: :error
    end
  end

  private

  def email_params
    params.permit(:email, :confirmation_token)
  end
end
