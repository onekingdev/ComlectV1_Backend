# frozen_string_literal: true

class RiskSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :created_at,
             :updated_at,
             :impact,
             :likelihood,
             :compliance_policy_ids,
             :risk_level
end
