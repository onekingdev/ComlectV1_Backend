# frozen_string_literal: true
class Question < ActiveRecord::Base
  belongs_to :project
  has_one :answer
  has_many :flags
  validates :project, presence: true
  validates :text, presence: true

  def to_s
    text
  end
end
