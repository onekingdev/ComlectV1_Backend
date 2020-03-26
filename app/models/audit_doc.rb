# frozen_string_literal: true

class AuditDoc < ActiveRecord::Base
  belongs_to :business
  belongs_to :audit_request
  include DocUploader[:file]
  include PdfUploader[:pdf]
  validates :file, presence: true
end
