# frozen_string_literal: true
class Message::Decorator < ApplicationDecorator
  decorates Message
  delegate_all

  delegate :message, to: :model

  def thread_key(subject)
    other = other_party(subject)
    thread ? "#{thread_type}/#{thread_id}" : "direct/#{other.class.name}/#{other.id}"
  end

  def thread_name(subject)
    thread ? thread.to_s : other_party(subject).to_s
  end
end
