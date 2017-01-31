# frozen_string_literal: true
class NotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def notification(dispatcher, action_url = nil, subject = "Notification on Complect")
    to = dispatcher.user.email
    @message = dispatcher.message_mail
    @action_label = dispatcher.action_label
    @action_url = action_url
    @initiator_name = dispatcher.initiator_name
    @img_path = dispatcher.img_path
    @subject = dispatcher.subject ? dispatcher.subject : subject
    mail to: to, subject: @subject, template_id: template_by_initiator(@initiator_name),
         template_model: {
           subject: @subject, message_html: simple_format(@message),
           message_text: @message, action_label: @action_label,
           action_url: action_url, initiator: @initiator_name, img_path: @img_path
         }
  end

  private

  def template_by_initiator(name)
    if name == "Complect"
      ENV.fetch('POSTMARK_COMPLECT_TEMPLATE_ID')
    else
      ENV.fetch('POSTMARK_PERSONALITY_TEMPLATE_ID')
    end
  end
end
