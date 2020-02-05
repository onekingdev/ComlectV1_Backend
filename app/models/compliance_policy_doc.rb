# frozen_string_literal: true

class CompliancePolicyDoc < ActiveRecord::Base
  include DocUploader[:doc]
  include PdfUploader[:pdf]
  default_scope { order(created_at: :desc) }
  validates :doc, presence: true
end
