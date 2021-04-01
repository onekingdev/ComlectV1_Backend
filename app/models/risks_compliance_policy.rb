# frozen_string_literal: true

class RisksCompliancePolicy < ApplicationRecord
  belongs_to :compliance_policy
  belongs_to :risk
end
