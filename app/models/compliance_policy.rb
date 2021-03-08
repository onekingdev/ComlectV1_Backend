# frozen_string_literal: true

class CompliancePolicy < ActiveRecord::Base
  acts_as_list
  belongs_to :business
  has_many :compliance_policy_docs, dependent: :destroy
  has_many :compliance_policy_sections, dependent: :destroy
  accepts_nested_attributes_for :compliance_policy_docs
  # validates :compliance_policy_docs, presence: true
  validates :title, presence: true, if: :section_blank?
  validates :section, inclusion: { in: I18n.translate('compliance_manual_sections').keys.map(&:to_s) }, if: :section_present?
  validate :section_business_uniqueness, if: :section_present?

  include PdfUploader[:pdf]

  before_save :wipe_title

  delegate :blank?, to: :section, prefix: true

  delegate :present?, to: :section, prefix: true

  def section_or_title
    section.blank? ? title : I18n.translate('compliance_manual_sections')[section.to_sym]
  end

  def set_last_upload_date
    update(last_uploaded: compliance_policy_docs.order(:created_at).collect(&:created_at).first)
  end

  def section_to_sym
    section.blank? ? nil : section.to_sym
  end

  def calculate_docs
    update(docs_count: compliance_policy_docs.where.not(pdf_data: nil).count)
  end

  def outdated?
    compliance_policy_docs.where('created_at > ?', Time.zone.today - 1.year).none?
  end

  private

  def wipe_title
    self.title = '' if section.present?
  end

  def section_business_uniqueness
    errors.add(:section, :section_taken) if business.compliance_policies.where(section: section).where.not(id: id).count.positive?
  end
end
