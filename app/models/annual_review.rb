# frozen_string_literal: true

class AnnualReview < ActiveRecord::Base
  include DocUploader[:file]
  include PdfUploader[:pdf]
  belongs_to :business
  validates :year, inclusion: ((Time.zone.today.year - 4)..Time.zone.today.year).to_a
  validates :file, presence: true
end
