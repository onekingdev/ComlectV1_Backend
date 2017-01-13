# frozen_string_literal: true
class Message::Create < Draper::Decorator
  decorates Message
  delegate_all

  def self.call(project, attributes)
    new(project.messages.create(attributes)).tap do |message|
      Notification::Deliver.got_project_message!(message) if message.persisted?
    end
  end

  delegate :message, to: :model
end
