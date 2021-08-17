# frozen_string_literal: true

class MessageSerializer < ApplicationSerializer
  has_one :recipient, serializer: SenderRecipientSerializer
  has_one :sender, serializer: SenderRecipientSerializer
  attributes :id,
             :sender,
             :recipient,
             :message,
             :file,
             :created_at
end
