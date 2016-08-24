# frozen_string_literal: true
class ProjectMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def invite(invite)
    project_url = project_url(invite.project)
    message_text = invite.message + "\n\nProject Link: #{project_url}"
    message_html = simple_format(invite.message) + "<br>Project Link: <a href='#{project_url}'>#{invite.project}</a>"
    mail to: invite.specialist.user.email,
         reply_to: invite.project.business.contact_email,
         template_id: ENV.fetch('POSTMARK_PROJECT_INVITE_TEMPLATE'),
         template_model: {
           message_html: message_html,
           message_text: message_text
         }
  end
end
