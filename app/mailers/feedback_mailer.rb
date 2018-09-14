# frozen_string_literal: true

class FeedbackMailer < ApplicationMailer
  def notification(feedback)
    message_html = ''
    message_text = ''
    attrs = feedback.attributes.tap { |h| h.delete('updated_at') }
    attrs.each do |k, v|
      message_html += "<b>#{k}:</b> #{v}<br>"
      message_text += "#{k}: #{v}\n"
    end
    mail(
      to: ENV.fetch('CONTACT_EMAIL'),
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Enterprise Solutions Request',
        message_html: message_html,
        message_text: message_text
      }
    )
  end
end
