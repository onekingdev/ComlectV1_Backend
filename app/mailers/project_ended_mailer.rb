# frozen_string_literal: true

class ProjectEndedMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def business_message(project_id)
    @project = Project.find(project_id)
    business = @project.business
    mail to: "#{business.business_name} <#{business.user.email}>",
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "Project Ended",
           message_html: render('business_message.html'),
           message_text: render('business_message.text')
         }
  end

  def specialist_message(project_id)
    @project = Project.find(project_id)
    specialist = @project.specialist
    mail to: "#{specialist.full_name} <#{specialist.user.email}>",
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "Project Ended",
           message_html: render('specialist_message.html'),
           message_text: render('specialist_message.text')
         }
  end
end
