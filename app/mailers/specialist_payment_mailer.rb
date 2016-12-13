# frozen_string_literal: true
class SpecialistPaymentMailer < ApplicationMailer
  def transaction_error(transaction_id)
    transaction = Transaction.find(transaction_id)
    mail to: transaction.specialist.user.email,
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "Payments can't be processed, check account details",
           message_html: render('transaction_error.html'),
           message_text: render('transaction_error.text')
         }
  end
end
