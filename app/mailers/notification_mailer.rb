# frozen_string_literal: true
class NotificationMailer < ApplicationMailer
  def notification(to, message, action_label = nil, action_url = nil)
    @message = message
    @action_label = action_label
    @action_url = action_url
    mail to: to,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "Notification on Complect",
           message_html: render('notification.html'),
           message_text: render('notification.text')
         }
  end
end
