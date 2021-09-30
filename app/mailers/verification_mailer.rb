# frozen_string_literal: true

class VerificationMailer < ApplicationMailer
  def send_otp(email, otp)
    @otp_code = otp
    mail(
      to: email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Verify your login',
        message_html: "Verify your login<p>Below your one time passcode:</p><p><strong>#{otp}</strong></p><p>Sincerely, <br/>Complect Team</p>"
      }
    )
  end
end
