# frozen_string_literal: true

class EscalatedProjectMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def email_to_support(project_issue)
    @project_issue = project_issue
    @project = @project_issue.project
    mail to: 'help@complect.co',
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "The project \"#{@project.title}\" has been escalated",
           message_html: render('message_to_support.html'),
           message_text: render('message_to_support.text')
         }
  end

  def email_to_user(project_issue)
    @project = project_issue.project
    @user = project_issue.user
    mail to: @user.email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "The project \"#{@project.title}\" has been escalated",
           message_html: render('message_to_user.html'),
           message_text: render('message_to_user.text')
         }
  end
end
