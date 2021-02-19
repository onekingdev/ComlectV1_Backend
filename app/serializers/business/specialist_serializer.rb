# frozen_string_literal: true

class Business::SpecialistSerializer < ApplicationSerializer
  has_many :skills, serializer: SkillSerializer
  has_many :jurisdictions, serializer: JurisdictionSerializer
  has_many :industries, serializer: IndustrySerializer
  attributes :id,
             :photo,
             :first_name,
             :last_name,
             :former_regulator,
             :resume_data,
             :certifications,
             :visibility,
             :ratings_count,
             :ratings_total,
             :ratings_average,
             :time_zone,
             :username,
             :years_of_experience,
             :min_hourly_rate,
             :location

  def photo
    object.photo_url(:thumb)
  end

  def location
    [object.city, object.state, object.country].map(&:presence).compact.join(', ')
  end
end
