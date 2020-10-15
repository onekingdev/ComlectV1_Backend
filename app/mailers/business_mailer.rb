# frozen_string_literal: true

class BusinessMailer < ApplicationMailer
  def welcome(business)
    @business = business

    mail(
      to: @business.user.email,
      template_id: ENV.fetch('POSTMARK_PERSONAL_TEMPLATE_ID'),
      template_model: {
        subject: 'Welcome to Complect!',
        message_html: render_to_string(template: 'business_mailer/welcome')
      }
    )
  end
end
