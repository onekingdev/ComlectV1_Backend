# frozen_string_literal: true
class JobApplicationMailer < ApplicationMailer
  def withdraw(job_application)
    @specialist = job_application.specialist
    @project = job_application.project
    mail to: job_application.specialist.user.email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "Job application withdrawn",
           message_html: render('withdraw.html'),
           message_text: render('withdraw.text')
         }
  end
end
