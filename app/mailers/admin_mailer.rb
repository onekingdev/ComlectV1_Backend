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
    attachments["metrics-#{Time.zone.now.strftime('%d-%B-%Y')}.csv"] = { mime_type: 'text/csv',
                                                                         content: Metrics.new.to_csv }
    mail(
      to: 'hanh@complect.com, james@complect.com, kourindouhime@gmail.com',
      subject: "Metrics #{Time.zone.now.strftime('%d %B %Y')}"
    )
  end

  def new_ported_client_review(ported_business_id)
    pb = PortedBusiness.find_by(ported_business_id)
    return unless pb

    body = "#{Time.zone.now.strftime('%d %B %Y')}: #{pb.specialist.name} wants to add #{pb.company} (#{pb.email}) as a ported company."

    mail(
      to: 'alex.mamonchik@gmail.com',
      subject: 'Ported client review',
      body: body
    )
  end
end
