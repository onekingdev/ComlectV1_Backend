# frozen_string_literal: true

class Business::SpecialistBusinessRoleSerializer < ApplicationSerializer
  attributes \
    :id,
    :role,
    :photo,
    :status,
    :username,
    :last_name,
    :first_name,
    :specialist_id

  def photo
    object.specialist.photo_url(:thumb)
  end
end
