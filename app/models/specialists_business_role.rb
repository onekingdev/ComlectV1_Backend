# frozen_string_literal: true

class SpecialistsBusinessRole < ActiveRecord::Base
  belongs_to :business
  belongs_to :specialist

  ROLES = %w[basic admin trusted].freeze

  validates :role, inclusion: { in: ROLES }

  enum role: {
    basic: 0,
    admin: 1,
    trusted: 2
  }
end
