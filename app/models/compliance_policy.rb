# frozen_string_literal: true

class CompliancePolicy < ActiveRecord::Base
  belongs_to :business
  has_many :compliance_policy_docs
  accepts_nested_attributes_for :compliance_policy_docs
  validates :compliance_policy_docs, presence: true
end
