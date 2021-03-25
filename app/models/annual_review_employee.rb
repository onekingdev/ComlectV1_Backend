# frozen_string_literal: true

class AnnualReviewEmployee < ActiveRecord::Base
  belongs_to :annual_report
  validates :name, presence: true
end
