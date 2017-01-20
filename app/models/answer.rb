# frozen_string_literal: true
class Answer < ActiveRecord::Base
  belongs_to :question
  has_many :flags, as: :flagged_content, dependent: :nullify
  validates :question, presence: true
  validates :text, presence: true
  delegate :project, to: :question, allow_nil: true

  def to_s
    text
  end
end
