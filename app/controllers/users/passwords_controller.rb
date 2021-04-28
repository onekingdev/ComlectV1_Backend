# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  include ActionView::Helpers::TagHelper
  def new
    render html: content_tag('reset-password-page', '').html_safe, layout: 'vue_onboarding'
  end

  def create
    user = User.find_by(email: resource_params[:email])
    resource_params[:email] = user.business.contact_email if user&.business&.contact_email.present?
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    render :new unless successfully_sent?(resource)
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
