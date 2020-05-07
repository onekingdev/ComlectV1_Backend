# frozen_string_literal: true

class MessageMailerJob < ApplicationJob
  queue_as :mailers

  def perform(message_id = nil)
    return process_all if message_id.nil?
  end

  private

  def process_all
    Message.notifiable.each do |message|
      next unless message.recipient.user.notifications.where(
        associated_type: 'Project',
        associated_id: message.thread_id,
        key: 'got_project_message',
        read_at: nil
      ).count.zero?
      Notification::Deliver.got_project_message!(message) unless message.read_by_recipient
      unread_messages = message.thread.messages.unread.where(recipient_id: message.recipient_id)
      unread_messages.update_all(read_by_recipient: true)
    end
  end
end
