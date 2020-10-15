# frozen_string_literal: true

class SpecialistMailer < ApplicationMailer
  def welcome(specialist)
    @specialist = specialist

    mail(
      to: @specialist.user.email,
      template_id: ENV.fetch('POSTMARK_PERSONAL_TEMPLATE_ID'),
      template_model: {
        subject: 'Welcome to Complect!',
        message_html: render_to_string(template: 'specialist_mailer/welcome')
      }
    )
  end
end
