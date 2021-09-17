# frozen_string_literal: true

class SpecialistSerializer < ApplicationSerializer
  has_many :skills, serializer: SkillSerializer
  has_many :industries, serializer: IndustrySerializer
  has_many :jurisdictions, serializer: JurisdictionSerializer
  attributes \
    :id,
    :username,
    :time_zone,
    :last_name,
    :first_name,
    :resume_url,
    :photo_url,
    :experience,
    :sub_industries,
    :former_regulator,
    :specialist_other,
    :seat_role,
    :plan,
    :description,
    :visibility,
    :min_hourly_rate,
    :name_setting

  def photo_url
    object.photo_url(:profile)
  end
end
