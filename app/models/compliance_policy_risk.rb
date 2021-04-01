# frozen_string_literal: true

class CompliancePolicyRisk < ApplicationRecord
  belongs_to :compliance_policy

  validates :name, presence: true
  validates :status, presence: true
  validates :compliance_policy_id, presence: true
  validate if: -> { compliance_policy_id.present? } do
    errors.add :compliance_policy_id, :invalid if compliance_policy.business_id != business_id
  end
end
