# frozen_string_literal: true

class BusinessSpecialistsRole < ActiveRecord::Base
  belongs_to :business
  belongs_to :specialist

  enum role: {
    basic: 0,
    admin: 1,
    trusted: 2
  }
end
