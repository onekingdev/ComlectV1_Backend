# frozen_string_literal: true

class MessageMailerJob < ApplicationJob
  queue_as :mailers

  def perform(message_id = nil)
    return process_all if message_id.nil?
    message = Message.find_by(id: message_id)
    Notification::Deliver.got_project_message!(message) unless message.read_by_recipient
    unread_messages = message.thread.messages.unread.where(recipient_id: message.recipient_id)
    unread_messages.update_all(read_by_recipient: true)
  end

  private

  def process_all
    Message.notifiable.each do |message|
      self.class.perform_later message.id
    end
  end
end
