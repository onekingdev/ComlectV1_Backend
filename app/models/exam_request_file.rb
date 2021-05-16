# frozen_string_literal: true

class ExamRequestFile < ApplicationRecord
  belongs_to :exam_request
  include FileUploader[:file]
end
