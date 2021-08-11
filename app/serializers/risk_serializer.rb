# frozen_string_literal: true

class RiskSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :created_at,
             :updated_at,
             :impact,
             :likelihood,
             :compliance_policies,
             :risk_level

  # def compliance_policies
  #  object.compliance_policies.select(:id, :name, :status, :created_at, :updated_at)
  # end
end
