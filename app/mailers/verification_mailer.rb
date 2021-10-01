# frozen_string_literal: true

class VerificationMailer < ApplicationMailer
  def send_otp(email, otp)
    @otp_code = otp
    mail(
      to: email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Your verification code',
        html_body: render_to_string(template: 'otp/mailer/otp.html.slim')
      }
    )
  end
end
