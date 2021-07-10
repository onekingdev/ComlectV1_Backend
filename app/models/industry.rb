# frozen_string_literal: true

class Industry < ApplicationRecord
  has_and_belongs_to_many :businesses, optional: true
  has_and_belongs_to_many :forum_questions, optional: true
  has_and_belongs_to_many :specialists, optional: true
  scope :sorted, -> { order("CASE WHEN (name = 'Other') THEN 0 ELSE 1 END DESC, name") }
  scope :filtered, -> { where.not(name: ['Recruiter', 'Consulting Firm']) }

  def to_s
    name
  end
end
