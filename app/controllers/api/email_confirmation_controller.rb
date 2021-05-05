# frozen_string_literal: true

class Api::EmailConfirmationController < ApiController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def update
    user = User.find(params[:user_id])
    if !user.email_confirmed && user.verify_otp(params[:otp_secret])
      user.update(email_confirmed: true)
      sign_in(:user, user)
      if user.business
        render json: { message: 'Email was successfully confirmed', token: JsonWebToken.encode(sub: user.id),
                       business: BusinessSerializer.new(user.business).serializable_hash }
      elsif user.specialist
        render json: { message: 'Email was successfully confirmed', token: JsonWebToken.encode(sub: user.id),
                       specialist: SpecialistSerializer.new(user.specialist).serializable_hash }
      end
    else
      respond_with message: 'Invalid 6 digits code'
    end
  end

  def resend
    user = User.find(params[:user_id])
    if user.email_confirmed
      respond_with errors: 'You have already confimed email'
    else
      BusinessMailer.verify_email(user, user.otp).deliver!
      respond_with message: 'You have received one time passcode to confirm your email'
    end
  end
end
