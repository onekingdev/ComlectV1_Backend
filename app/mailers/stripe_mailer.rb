# frozen_string_literal: true
class StripeMailer < ApplicationMailer
  def verification_needed(email)
    mail to: email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: 'Account verification needed',
           message_html: render('verification_needed.html'),
           message_text: render('verification_needed.text')
         }
  end

  def charge_failed(email)
    mail to: email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: 'Charge failed',
           message_html: render('charge_failed.html'),
           message_text: render('charge_failed.text')
         }
  end

  def transfer_failed(email)
    mail to: email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: 'Payment failed',
           message_html: render('transfer_failed.html'),
           message_text: render('transfer_failed.text')
         }
  end
end
