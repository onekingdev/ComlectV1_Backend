# frozen_string_literal: true

class Specialist::Team < ApplicationRecord
  belongs_to :manager, class_name: 'Specialist'
  has_many :employees, class_name: 'Specialist', foreign_key: :specialist_team_id
  has_many :invitations, foreign_key: :specialist_team_id
end
