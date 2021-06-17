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
