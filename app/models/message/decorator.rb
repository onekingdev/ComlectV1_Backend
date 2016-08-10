# frozen_string_literal: true
class Message::Decorator < ApplicationDecorator
  decorates Message
  delegate_all

  delegate :message, to: :model
end
