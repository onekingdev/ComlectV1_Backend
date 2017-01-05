# frozen_string_literal: true
class StripeMailer < ApplicationMailer
  def verification_needed
    mail to: email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: 'Account verification needed',
           message_html: render('verification_needed.html'),
           message_text: render('verification_needed.text')
         }
  end
end
