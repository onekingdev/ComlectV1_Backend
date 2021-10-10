# frozen_string_literal: true

class Message::Create < Draper::Decorator
  decorates Message
  delegate_all

  def self.call(project, attributes, sender, recipient)
    if project.nil?
      create_msg(attributes)
    elsif recipient.nil?
      create_msg(attributes.merge(thread: project))
    end
  end

  delegate :message, to: :model

  def self.create_msg(attributes)
    Message.create(attributes)
  end
end
