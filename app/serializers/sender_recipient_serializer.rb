# frozen_string_literal: true

class SenderRecipientSerializer < ApplicationSerializer
  attributes :first_name,
             :last_name,
             :photo

  def photo
    object.photo_url(:thumb)
  end
end
