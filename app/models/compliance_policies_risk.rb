# frozen_string_literal: true

class CompliancePoliciesRisk < ActiveRecord::Base
  belongs_to :compliance_policy
  belongs_to :risk
  validates :compliance_policy_id, uniqueness: { scope: :risk_id }
  validate :policy_belongs_to_business

  private

  def policy_belongs_to_business
    return errors.add :compliance_policy_id if risk.business.id != compliance_policy.business.id
  end
end
