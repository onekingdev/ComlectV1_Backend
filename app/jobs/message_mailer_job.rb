# frozen_string_literal: true

class MessageMailerJob < ApplicationJob
  queue_as :mailers

  def perform(message_id = nil)
    return process_all if message_id.nil?
    # message = Message.find_by(id: message_id)
    # unread_messages = message.thread.messages.unread.where(recipient_id: message.recipient_id)
    # unread_messages.update_all(read_by_recipient: true)
    # Notification::Deliver.got_project_message!(message)
  end

  private

  def process_all
    LocalProject.where(has_unread_messages: true).each do |local_project|
      most_unread_id = LocalProjectsSpecialist.where(local_project: local_project).collect(&:last_read_message_id).push(local_project.last_read_message_id).min
      last_msg = local_project.messages.where('created_at < ?', Time.zone.now - 2.minutes).order(:id).last
      last_msg_id = last_msg&.id
      last_msg_sender = last_msg&.sender
      next if last_msg_id.nil? || most_unread_id >= last_msg_id
      # check business
      if local_project.last_read_message_id < last_msg_id
        local_project.update_column('last_read_message_id', last_msg_id)
        Notification::Deliver.got_project_message!(local_project.owner.user, local_project, last_msg_sender) if last_msg_sender != local_project.owner
      end
      LocalProjectsSpecialist.where(local_project_id: local_project.id).each do |lspecialist|
        if lspecialist.last_read_message_id < last_msg_id
          lspecialist.update_column('last_read_message_id', last_msg_id)
          Notification::Deliver.got_project_message!(lspecialist.specialist.user, local_project, last_msg_sender) if last_msg_sender != lspecialist.specialist
        end
      end
      local_project.update_column('has_unread_messages', false)
    end
  end
end
