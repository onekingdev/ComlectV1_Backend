# frozen_string_literal: true

class Api::PasswordsController < ApiController
  skip_before_action :authenticate_user!, only: %i[create update]
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def create
    user = User.find_by(email: params[:email])
    params[:email] = user.business.contact_email if user&.business&.contact_email.present?
    if user.send_reset_password_instructions
      respond_with message: I18n.t('api.passwords.reset_email'), status: :ok
    else
      respond_with error: 'Internal error', status: :unprocessable_entity
    end
    # self.resource = resource_class.send_reset_password_instructions(resource_params)
    # render :new unless successfully_sent?(resource)
  end

  def update
    user = User.reset_password_by_token(reset_params)
    if user.errors.empty?
      respond_with message: 'done'
    else
      respond_with errors: user.errors, status: :unprocessable_entity
    end
  end

  private

  def reset_params
    params.require(:user).permit(:password, :password_confirmation, :reset_password_token)
  end
end
