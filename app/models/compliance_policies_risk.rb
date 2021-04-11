# frozen_string_literal: true

class CompliancePoliciesRisk < ActiveRecord::Base
  belongs_to :compliance_policy
  belongs_to :risk
end
