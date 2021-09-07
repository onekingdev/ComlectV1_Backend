# frozen_string_literal: true

class CompliancePolicySerializer < ApplicationSerializer
  has_many :versions, serializer: CompliancePolicyWithoutVersionsSerializer
  has_many :risks, serializer: RiskSerializer
  has_many :reminders, serializer: ReminderSerializer
  attributes :id,
             :name,
             :created_at,
             :updated_at,
             :position,
             :description,
             :src_id,
             :status,
             :sections,
             :versions,
             :archived,
             :reminders,
             :published_by,
             :pdf

  def status
    return 'archived' if object.archived
    return 'published' if object.untouched && object.versions.present?
    object.status
  end

  def pdf
    return object.versions.first.pdf_url if object.status == 'draft' && object.untouched
    object.pdf_url
  end
end
