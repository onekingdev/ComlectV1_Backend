# frozen_string_literal: true

class SpecialistSerializer < ApplicationSerializer
  has_many :skills, serializer: SkillSerializer
  has_many :industries, serializer: IndustrySerializer
  attributes :id,
             :first_name,
             :last_name,
             :resume_url,
             :username,
             :experience,
             :former_regulator
end
