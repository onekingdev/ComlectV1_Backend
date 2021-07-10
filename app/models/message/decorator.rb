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

  def form_url
    if sender_type == 'Business'
      h.url_for [:business, self, { project_id: project.id }]
    else
      h.url_for [sender_type.underscore.to_sym, self, { project_id: project.id }]
    end
  end
end
