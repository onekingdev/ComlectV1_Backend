# frozen_string_literal: true
class MessageMailer < ApplicationMailer
  def first_contact(from, to, message_text)
    from_name = from.is_a?(Specialist) ? from.first_name : from.business_name
    to_name = to.is_a?(Specialist) ? to.full_name : to.contact_full_name
    @message = message_text
    @from = from_name
    mail to: "#{to_name} <#{to.user.email}>",
         subject: "Message from #{from_name} on Complect",
         reply_to: ENV.fetch('POSTMARK_INBOUND_ADDRESS')
  end
end
