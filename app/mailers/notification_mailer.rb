# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  # rubocop:disable Metrics/ParameterLists
  def notification(to, message, action_label, initiator_name, img_path, action_url, subject)
    @message = message
    @action_label = action_label
    @action_url = action_url
    @initiator_name = initiator_name
    @img_path = img_path
    @action_url = action_url
    @subject = subject || 'Notification on Complect'

    mail(
      to: to,
      template_id: template_by_initiator(@initiator_name),
      template_model: {
        subject: @subject,
        message_html: simple_format(@message),
        message_text: @message,
        action_label: @action_label,
        action_url: @action_url,
        initiator: @initiator_name,
        img_path: @img_path
      }
    )
  end
  # rubocop:enable Metrics/ParameterLists

  private

  def template_by_initiator(name)
    if name == 'Complect'
      ENV.fetch('POSTMARK_COMPLECT_TEMPLATE_ID')
    else
      ENV.fetch('POSTMARK_PERSONALITY_TEMPLATE_ID')
    end
  end
end
