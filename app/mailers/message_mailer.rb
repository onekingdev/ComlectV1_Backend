# frozen_string_literal: true
class MessageMailer < ApplicationMailer
  def first_contact(from, to, message_text)
    @message = message_text
    @from = confidential_party_name(from)
    thread = EmailThread.for!(from, to)
    mail to: to_address(to),
         subject: subject(from),
         reply_to: thread_address(thread, from)
  end

  def reply(thread, original_sender, message_text, message_html)
    to = original_sender == 'business' ? thread.business : thread.specialist
    from = original_sender == 'business' ? thread.specialist : thread.business
    thread = EmailThread.for!(from, to)
    @message_text = message_text
    @message_html = message_html
    mail to: to_address(to),
         subject: "RE: #{subject(from)}",
         reply_to: thread_address(thread, from)
  end

  private

  def subject(from)
    from.is_a?(Business) && from.anonymous? ? "Message on Complect" : "Message from #{party_name(from)} on Complect"
  end

  def confidential_party_name(party)
    party_name(party) unless party.is_a?(Business) && party.anonymous?
  end

  def party_name(party)
    party.is_a?(Business) ? party.business_name : party.first_name
  end

  def to_address(to)
    "#{party_name(to)} <#{to.user.email}>"
  end

  def thread_address(thread, from)
    sender = { 'Business' => 'business', 'Specialist' => 'specialist' }.fetch(from.class.name)
    ENV.fetch('POSTMARK_INBOUND_ADDRESS').split('@').join("+#{thread.thread_key}+#{sender}@")
  end
end
