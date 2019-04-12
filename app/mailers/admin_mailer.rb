# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def admin_email(email, subject, body)
    @body = body

    mail(
      to: email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: subject,
        message_html: render('admin_email.html'),
        message_text: render('admin_email.text')
      }
    )
  end

  def metrics_csv
    attachments['metrics.csv'] = { mime_type: 'text/csv',
                                   content: Metrics.new.to_csv }
    mail(
      to: 'kourindouhime@gmail.com',
      subject: "Metrics #{Time.zone.now.strftime('%d %B %Y')}"
    )
  end
end
