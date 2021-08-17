# frozen_string_literal: true

class Api::EmailConfirmationController < ApiController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def update
    user = User.find_by(email: params[:email])
    render(json: { message: 'Invalid code length' }) && return if params[:otp_secret].length != 6
    if !user.confirmed_at && user.verify_otp(params[:otp_secret])
      user.update(confirmed_at: Time.zone.now)
      sign_in(:user, user)
      if user.business
        render json: { message: I18n.t('api.email_confirmation.confirmed'), token: JsonWebToken.encode(sub: user.id),
                       business: BusinessSerializer.new(user.business).serializable_hash }
      elsif user.specialist
        render json: { message: I18n.t('api.email_confirmation.confirmed'), token: JsonWebToken.encode(sub: user.id),
                       specialist: SpecialistSerializer.new(user.specialist).serializable_hash }
      end
    else
      respond_with message: I18n.t('api.email_confirmation.invalid_otp')
    end
  end

  def resend
    user = User.find_by(email: params[:email])
    if user.confirmed_at
      respond_with errors: I18n.t('api.email_confirmation.already_confirmed')
    else
      BusinessMailer.verify_email(user, user.otp).deliver!
      respond_with message: I18n.t('api.email_confirmation.otp_sent')
    end
  end
end
