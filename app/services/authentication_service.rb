# frozen_string_literal: true

class AuthenticationService < ApplicationService
  OTP_LENGTH = 6

  attr_reader :ctrl, :params, :data, :status, :user

  def initialize(ctrl, params)
    @ctrl = ctrl
    @data = {}
    @params = params
  end

  def call
    return self if params_invalid?
    return self if user_not_found?
    return self if password_invalid?
    return self if otp_was_generated?
    return self if otp_invalid?
    return self if otp_was_not_verified?

    sign_in_user

    self
  end

  def success?
    @success
  end

  private

  def params_invalid?
    result = login_fields.each_with_object({}) do |field, hash|
      if params[:user][field].blank?
        hash[field] = ['Required field']
      end
    end

    result.present? ? assign_422_errors(result) : false
  end

  def user_not_found?
    @user = User.find_first_by_auth_conditions(email: params[:user][:email])

    if user.blank?
      assign_422_error(I18n.t('api.authentication.invalid'))
    elsif !user.confirmed?
      assign_422_error(I18n.t('devise.failure.unconfirmed'))
    else
      false
    end
  end

  def password_invalid?
    if user.valid_password?(params[:user][:password])
      false
    else
      assign_422_errors(password: ['Password is incorrect'])
    end
  end

  def otp_was_generated?
    unless params.key?(:otp_secret)
      user.email_otp
      assign_success_msg(
        router_name: 'verification',
        email_verified: user.confirmed?,
        message: I18n.t('api.authentication.otp_sent')
      )
    end
  end

  def otp_invalid?
    otp = params[:otp_secret]

    if otp.blank? || otp.size != OTP_LENGTH
      assign_422_errors(invalid: 'Invalid code length')
    end
  end

  def otp_was_not_verified?
    unless user.verify_otp(params[:otp_secret])
      assign_422_errors(invalid: I18n.t('api.authentication.invalid_otp'))
    end
  end

  def sign_in_user
    ctrl.sign_in(:user, user)
    user.update(jwt_hash: SecureRandom.hex(10)) if user.jwt_hash.nil?

    result = {
      token: JsonWebToken.encode(sub: user.id, jwt_hash: user.jwt_hash)
    }

    if user.business
      result[:business] = BusinessSerializer.new(user.business).serializable_hash
    elsif user.specialist
      result[:specialist] = SpecialistSerializer.new(user.specialist).serializable_hash
    end

    assign_success_msg(result)
  end

  def login_fields
    %i[email password]
  end

  def assign_422_error(msg)
    @data[:error] = msg
    @status = :unprocessable_entity
    true
  end

  def assign_422_errors(data)
    @data[:errors] = data
    @status = :unprocessable_entity
    true
  end

  def assign_success_msg(options = {})
    @status = :ok
    @data = data.merge(options)

    true
  end
end
