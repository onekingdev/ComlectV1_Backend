# frozen_string_literal: true

class MessageSerializer < ApplicationSerializer
  has_one :recipient, serializer: SenderRecipientSerializer
  has_one :sender, serializer: SenderRecipientSerializer
  attributes :id,
             :sender,
             :recipient,
             :message,
             :file_url,
             :file_name,
             :created_at

  def file_name
    object.file.present? ? object.file_name : nil
  end
end
