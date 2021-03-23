# frozen_string_literal: true

class ExamRequest < ApplicationRecord
  belongs_to :exam
  has_one :business, through: :exam
  has_many exam_request_files
end
