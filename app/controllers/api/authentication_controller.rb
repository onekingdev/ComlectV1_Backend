# frozen_string_literal: true

class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token

  def create
    user = User.find_first_by_auth_conditions(email: params[:user][:email])

    # maybe need to add re-send email confirmation option
    respond_with(errors: 'Please, confirm your email') && return unless user.email_confirmed

    if user&.valid_password?(params[:user][:password])
      unless params[:otp_secret]
        user.email_otp
        render(json: { message: 'You have received one time passcode on your email to verify login' }) && return
      end
      if user.verify_otp(params[:otp_secret])
        sign_in(:user, user)
        user.update(jwt_hash: SecureRandom.hex(10)) if user.jwt_hash.nil?
        if user.business
          render json: { token: JsonWebToken.encode(sub: user.id, jwt_hash: user.jwt_hash),
                         business: BusinessSerializer.new(user.business).serializable_hash }
        elsif user.specialist
          render json: { token: JsonWebToken.encode(sub: user.id, jwt_hash: user.jwt_hash),
                         specialist: SpecialistSerializer.new(user.specialist).serializable_hash }
        end
      else
        render json: { errors: { invalid: 'Invalid secret key' } }, status: :unprocessable_entity
      end
    else
      render json: { errors:
                    { invalid: I18n.t('devise.failure.invalid', authentication_keys: 'email') } }, status: :unprocessable_entity
    end
  end

  def destroy
    # de-auth all
    session.delete(:employee_business_id)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))

    token = request.headers["Authorization"]
    payload = JsonWebToken.decode(token)
    user = User.find(payload['sub'])
    user.update(jwt_hash: SecureRandom.hex(10))
    render json: { result: "signed_out" }
  end
end
