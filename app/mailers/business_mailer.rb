# frozen_string_literal: true

class BusinessMailer < ApplicationMailer
  def welcome(business)
    @business = business

    mail(
      to: @business.user.email,
      template_id: ENV.fetch('POSTMARK_PERSONAL_TEMPLATE_ID'),
      template_model: {
        subject: 'Welcome to Complect!',
        message_html: render_to_string(template: 'business_mailer/welcome')
      }
    )
  end

  def verify_email(user, otp_code)
    @otp_code = otp_code
    @user = user

    mail(
      to: @user.email,
      template_model: {
        subject: 'Confirm your email',
        message_html: render_to_string(template: 'business_mailer/verify_email')
      }
    )
  end
end
