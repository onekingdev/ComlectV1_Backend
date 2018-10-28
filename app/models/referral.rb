# frozen_string_literal: true

class Referral < ApplicationRecord
  belongs_to :referral_code
  belongs_to :invitable, polymorphic: true

  validates :invitable, unique: true
end
