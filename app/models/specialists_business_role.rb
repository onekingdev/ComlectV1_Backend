# frozen_string_literal: true

class SpecialistsBusinessRole < ActiveRecord::Base
  ROLES = %w[basic admin trusted].freeze

  enum role: { basic: 0, admin: 1, trusted: 2 }
  enum status: { active: 'active', inactive: 'inactive' }

  belongs_to :business
  belongs_to :specialist

  validates :role, inclusion: { in: ROLES }

  delegate :first_name, :last_name, :username, to: :specialist
end
