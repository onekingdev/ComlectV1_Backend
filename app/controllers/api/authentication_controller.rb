# frozen_string_literal: true

class Api::AuthenticationController < ApiController
  skip_before_action :authenticate_user!, only: :create
  skip_before_action :verify_authenticity_token
  skip_before_action :lock_specialist, only: :destroy

  def create
    if params[:user].nil? || params[:user][:email].nil? || params[:user][:password].nil?
      render(json: { errors: 'Required fields are empty' }, status: :bad_request) && return
    end
    user = User.find_first_by_auth_conditions(email: params[:user][:email])
    render(json: { errors: I18n.t('api.authentication.invalid') }, status: :unprocessable_entity) && return if user.nil?
    render(json: { errors: I18n.t('api.authentication.confirm_email') }, status: :created) && return unless user.confirmed_at
    # respond_with(errors: "User not found") && return if user.nil?

    if user&.valid_password?(params[:user][:password])
      unless params[:otp_secret]
        user.email_otp
        render(json: { message: I18n.t('api.authentication.otp_sent') }) && return
      end
      render(json: { errors: { invalid: 'Invalid code length' } }, status: :unprocessable_entity) && return if params[:otp_secret].to_s.length != 6
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
        render json: { errors: { invalid: I18n.t('api.authentication.invalid_otp') } }, status: :unprocessable_entity
      end
    else
      render json: { errors:
                    { invalid: I18n.t('devise.failure.invalid', authentication_keys: 'email') } }, status: :unprocessable_entity
    end
  end

  def destroy
    # de-auth all
    session.delete(:employee_business_id)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    begin
      token = request.headers['Authorization']
      payload = JsonWebToken.decode(token)
      user = User.find(payload['sub'])
      user.update(jwt_hash: SecureRandom.hex(10))
    rescue
      Rails.logger.info 'fixme: session signout bug'
    end
    render json: { result: 'signed_out' }
  end
end
