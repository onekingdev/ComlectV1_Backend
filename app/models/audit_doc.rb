# frozen_string_literal: true

class AuditDoc < ActiveRecord::Base
  belongs_to :business
  include DocUploader[:file]
  include PdfUploader[:pdf]
end
