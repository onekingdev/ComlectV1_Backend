# frozen_string_literal: true

class RiskSerializer < ApplicationSerializer
  has_many :compliance_policies, serializer: CompliancePolicySerializer
  attributes :id,
             :name,
             :created_at,
             :updated_at,
             :impact,
             :likelihood,
             :compliance_policies
end
