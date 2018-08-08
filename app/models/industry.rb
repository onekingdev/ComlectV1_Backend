# frozen_string_literal: true

class Industry < ApplicationRecord
  has_and_belongs_to_many :businesses
  has_and_belongs_to_many :turnkey_solutions

  scope :sorted, -> { order(name: :asc) }

  def to_s
    name
  end
end
