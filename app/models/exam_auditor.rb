# frozen_string_literal: true

class ExamAuditor < ApplicationRecord
  belongs_to :exam
  validates :exam_id, presence: true
  validates :email, presence: true
end
