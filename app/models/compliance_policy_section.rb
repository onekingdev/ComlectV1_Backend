# frozen_string_literal: true

class CompliancePolicySection < ApplicationRecord
  belongs_to :compliance_policy
  has_one :business, through: :compliance_policy
  has_many :children, -> { order(order: :desc) }, class_name: 'CompliancePolicySection', foreign_key: :parent_id
  belongs_to :parent, class_name: 'CompliancePolicySection', foreign_key: :parent_id
  validates :name, presence: true
  validate if: -> { parent_id.present? } do
    errors.add :parent_id, :invalid if parent.business.id != compliance_policy.business_id
  end
end
