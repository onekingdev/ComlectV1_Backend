# frozen_string_literal: true

class Question < ApplicationRecord
  belongs_to :project
  belongs_to :specialist
  has_one :answer
  has_many :flags, as: :flagged_content, dependent: :nullify
  validates :project, presence: true
  validates :text, presence: true
  validates :specialist, presence: true

  def to_s
    text
  end
end
