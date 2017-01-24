# frozen_string_literal: true
class Question < ActiveRecord::Base
  belongs_to :project
  belongs_to :specialist
  has_one :answer
  has_many :flags
  validates :project, presence: true
  validates :text, presence: true
  validates :specialist, presence: true

  def to_s
    text
  end
end
