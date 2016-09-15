# frozen_string_literal: true
class AdminMailer < ApplicationMailer
  def admin_email(email, subject, body)
    @message_text = body
    @message_html = body
    mail to: email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: subject,
           message_html: render('admin_email.html'),
           message_text: render('admin_email.text')
         }
  end
end
