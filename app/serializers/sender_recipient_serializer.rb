# frozen_string_literal: true

class SenderRecipientSerializer < ApplicationSerializer
  attributes :name,
             :photo

  def photo
    object.class.name.include?('Business') ? object.logo_url(:thumb) : object&.photo_url(:thumb)
  end
end
