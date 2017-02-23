# frozen_string_literal: true
class MessageMailer < ApplicationMailer
  def first_contact(from, to, message_text, project)
    @message = message_text
    @project = project
    thread = EmailThread.for!(from, to)
    mail to: "Complect <#{ENV.fetch('DEFAULT_MAIL_FROM')}>",
         bcc: to_address(to),
         reply_to: thread_address(thread, from),
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: subject(from),
           message_html: render('first_contact.html'),
           message_text: render('first_contact.text')
         }
  end

  def reply(thread, original_sender, message_text, message_html, reply_text)
    to = original_sender == 'b' ? thread.business : thread.specialist
    from = original_sender == 'b' ? thread.specialist : thread.business
    thread = EmailThread.for!(from, to)
    @message_text = message_text
    @message_html = remove_template_html(message_html, reply_text)
    mail to: "Complect <#{ENV.fetch('DEFAULT_MAIL_FROM')}>",
         bcc: to_address(to),
         reply_to: thread_address(thread, from),
         template_id: ENV.fetch('POSTMARK_TEMPLATE_ID'),
         template_model: {
           subject: "RE: #{subject(from)}",
           message_html: render('reply.html'),
           message_text: render('reply.text')
         }
  end

  private

  def remove_template_html(html, reply_text)
    previous = (html.match(/id=.*?message-body".*?>(.*?)<div id=".*?message-body-end"/mi) || [])[1].to_s.strip
    reply_text + "<br/><br/>---<br/><br/>" + previous
  end

  def subject(_from)
    "You received a message on Complect"
  end

  def party_name(party)
    party.is_a?(Business) ? party.business_name : party.first_name
  end

  def to_address(to)
    "#{party_name(to)} <#{to.user.email}>"
  end

  def thread_address(thread, from)
    sender = { 'Business' => 'b', 'Specialist' => 's' }.fetch(from.class.name)
    prefix, server = ENV.fetch('POSTMARK_INBOUND_ADDRESS').split('@')
    prefix = 'thread' if prefix.blank?
    "#{prefix}+#{thread.thread_key}#{sender}@#{server}"
  end
end
