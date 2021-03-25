# frozen_string_literal: true

class LocalProjectsSpecialist < ApplicationRecord
  belongs_to :local_project
  belongs_to :specialist
end
