# frozen_string_literal: true

class Api::Settings::PasswordController < ApiController
  skip_before_action :verify_authenticity_token

  def update
    if current_user.update_with_password(password_params)
      bypass_sign_in current_user
      respond_with status: :ok
    else
      respond_with errors: current_user.errors, status: :fail
    end
  end

  private

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
