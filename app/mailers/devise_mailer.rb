# frozen_string_literal: true

class DeviseMailer < ApplicationMailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default from: "Complect <#{ENV.fetch('DEFAULT_MAIL_FROM')}>"

  def confirmation_instructions(record, token, _opts = {})
    @resource = record
    @token = token
    mail(
      to: @resource.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Email change confirmation',
        message_html: render('confirmation_instructions.html'),
      }
    )
  end

  def reset_password_instructions(record, token, _opts = {})
    @resource = record
    @token = token
    mail(
      to: @resource.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Reset password instructions',
        message_html: render('reset_password_instructions.html'),
        message_text: render('reset_password_instructions.text')
      }
    )
  end
end
