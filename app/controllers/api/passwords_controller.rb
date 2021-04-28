# frozen_string_literal: true

class Api::PasswordsController < ApiController
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token # TODO: proper authentication

  def create
    user = User.find_by(email: params[:email])
    params[:email] = user.business.contact_email if user&.business&.contact_email.present?
    if user.send_reset_password_instructions
      respond_with message: 'Password reset email has been sent', status: :ok
    else
      respond_with error: 'Internal error', status: :unprocessable_entity
    end
    # self.resource = resource_class.send_reset_password_instructions(resource_params)
    # render :new unless successfully_sent?(resource)
  end
end
