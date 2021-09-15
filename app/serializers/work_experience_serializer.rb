# frozen_string_literal: true

class WorkExperienceSerializer < ApplicationSerializer
  attributes :id, :company, :job_title, :start_date, :end_date, :current, :description
end
