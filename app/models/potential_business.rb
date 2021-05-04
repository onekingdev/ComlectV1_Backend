# frozen_string_literal: true

class PotentialBusiness < ActiveRecord::Base
  validates :crd_number, uniqueness: true
end
