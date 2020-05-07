# frozen_string_literal: true

class Message::Create < Draper::Decorator
  decorates Message
  delegate_all

  def self.call(project, attributes)
    # rubocop:disable Metrics/LineLength
    return if project.pending? && attributes[:sender].is_a?(Specialist) && project.messages.business_specialist(project.business_id, attributes[:sender].id).blank?
    # rubocop:enable Metrics/LineLength
    new(project.messages.create(attributes)).tap do |message|
      #  Notification::Deliver.got_project_message!(message) if message.persisted?
    end
  end

  delegate :message, to: :model
end
