# frozen_string_literal: true

class Exam < ApplicationRecord
  belongs_to :business
  has_many :exam_requests
  accepts_nested_attributes_for :exam_requests
end
