# frozen_string_literal: true

class CompliancePolicySection < ApplicationRecord
  belongs_to :compliance_policy
  belongs_to :business
  has_many :children, -> { order(order: :desc) }, class_name: 'CompliancePolicySection', foreign_key: :parent_id
  belongs_to :parent, class_name: 'CompliancePolicySection', foreign_key: :parent_id
  validates :name, presence: true
  validate if: -> { parent_id.present? } do
    errors.add :parent_id, :invalid if parent.business.id != business_id
  end
end
