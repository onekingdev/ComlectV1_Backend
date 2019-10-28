# frozen_string_literal: true

class CompliancePolicyDoc < ActiveRecord::Base
  include DocUploader[:doc]
  default_scope { order(created_at: :desc) }
end
