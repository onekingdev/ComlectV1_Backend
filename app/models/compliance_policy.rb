# frozen_string_literal: true

class CompliancePolicy < ActiveRecord::Base
  belongs_to :business
  has_many :compliance_policy_docs
  accepts_nested_attributes_for :compliance_policy_docs
  validates :compliance_policy_docs, presence: true
  validates :title, presence: true, if: :section_blank?
  validates :section, inclusion: { in: I18n.translate('compliance_manual_sections').keys.map(&:to_s) }, if: :section_present?

  delegate :blank?, to: :section, prefix: true

  delegate :present?, to: :section, prefix: true

  def section_or_title
    section.nil? ? title : I18n.translate('compliance_manual_sections')[section.to_sym]
  end

  def section_to_sym
    section.blank? ? nil : section.to_sym
  end
end
