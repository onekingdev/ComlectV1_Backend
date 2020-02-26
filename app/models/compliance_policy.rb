# frozen_string_literal: true

class CompliancePolicy < ActiveRecord::Base
  belongs_to :business
  has_many :compliance_policy_docs, dependent: :destroy
  accepts_nested_attributes_for :compliance_policy_docs
  validates :compliance_policy_docs, presence: true
  validates :title, presence: true, if: :section_blank?
  # rubocop:disable Metrics/LineLength
  validates :section, inclusion: { in: I18n.translate('compliance_manual_sections').keys.map(&:to_s) }, uniqueness: true, if: :section_present?
  # rubocop:enable Metrics/LineLength
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

  private

  def wipe_title
    self.title = '' if section.present?
  end
end
