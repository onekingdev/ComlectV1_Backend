# frozen_string_literal: true

class Specialist::SpecialistBusinessRoleSerializer < ApplicationSerializer
  attributes \
    :id,
    :role,
    :photo,
    :status,
    :specialist_id,
    :business_name

  def photo
    object.business.photo_url(:thumb)
  end

  def business_name
    object.business.business_name
  end
end
