# frozen_string_literal: true

class Industry < ApplicationRecord
  has_and_belongs_to_many :businesses
  has_and_belongs_to_many :turnkey_solutions
  has_and_belongs_to_many :forum_questions
  has_and_belongs_to_many :specialists
  scope :sorted, -> { order(name: :asc) }
  scope :filtered, -> { where.not(name: 'Consulting Firm') }

  def to_s
    name
  end
end
