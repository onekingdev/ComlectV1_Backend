# frozen_string_literal: true
class ProjectMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def invite(invite)
    mail to: invite.specialist.user.email,
         template_id: ENV.fetch('POSTMARK_PROJECT_INVITE_TEMPLATE'),
         template_model: {
           message_html: invite_message_html(invite),
           message_text: invite_message_text(invite)
         }
  end

  def share(project, name, email, message)
    @message = message
    @project_url = project_url(project)
    mail to: "#{name} <#{email}>", subject: "#{project.title} on Complect"
  end

  private

  def invite_message_html(invite)
    url = project_url(invite.project)
    simple_format(invite.message) + "<br>Project Link: <a href='#{url}'>#{invite.project}</a>".html_safe
  end

  def invite_message_text(invite)
    url = project_url(invite.project)
    invite.message + "\n\nProject Link: #{url}"
  end
end
