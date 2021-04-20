# frozen_string_literal: true

class Message::Create < Draper::Decorator
  decorates Message
  delegate_all

  def self.call(project, attributes, sender, recipient)
    if project.nil?
      if sender.class.name == 'Specialist' && recipient.class.name == 'Business'
        if Message.business_specialist(recipient.id, sender.id).direct.count.positive? ||
           sender.applied_projects.collect(&:business_id).include?(recipient.id)
          create_msg(attributes)
        end
      else
        create_msg(attributes)
      end
    elsif recipient.nil?
      project.messages.create(attributes)
    end
  end

  delegate :message, to: :model

  private

  def create_msg(attributes)
    new(Message.create(attributes)).tap do |message|
      Notification::Deliver.got_direct_message!(message) if message.persisted?
    end
  end
end
