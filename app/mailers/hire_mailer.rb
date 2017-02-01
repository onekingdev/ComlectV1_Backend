# frozen_string_literal: true
class HireMailer < ApplicationMailer
  def hired(application)
    application.project.full_time? ? hired_for_job(application) : hired_for_project(application)
  end

  private

  def hired_for_job(application)
    @project = application.project
    mail to: application.specialist.user.email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: 'You got the job!',
           message_html: render('hired_for_job.html'),
           message_text: render('hired_for_job.text')
         }
  end

  def hired_for_project(application)
    @project = application.project
    mail to: application.specialist.user.email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "You've been selected for a project!",
           message_html: render('hired_for_project.html'),
           message_text: render('hired_for_project.text')
         }
  end
end
