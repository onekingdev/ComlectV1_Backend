# frozen_string_literal: true
class ProjectMessageMailer < ApplicationMailer
  def notification(message_id)
    message = Message.find(message_id)
    project = message.thread
    message.sender == project.business ? specialist_notification(project) : business_notification(project)
  end

  private

  def specialist_notification(project)
    @project = project
    @url = specialists_dashboard_url(anchor: 'messages')
    default_notification @project.specialist.user.email
  end

  def business_notification(project)
    @project = project
    @url = business_dashboard_url(anchor: 'messages')
    default_notification @project.business.user.email
  end

  def default_notification(to)
    mail to: to,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "You've received a message",
           message_html: render('notification.html'),
           message_text: render('notification.text')
         }
  end
end
