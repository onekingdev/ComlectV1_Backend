# frozen_string_literal: true

class SpecialistMailer < ApplicationMailer
  include ActionView::Helpers::TextHelper

  def welcome(specialist)
    @specialist = specialist

    mail(
      to: @specialist.user.email,
      template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
      template_model: {
        subject: 'Welcome to Complect!',
        message_html: render_to_string(template: 'specialist_mailer/welcome')
      }
    )
  end
end
