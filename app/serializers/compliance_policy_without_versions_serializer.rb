# frozen_string_literal: true

class CompliancePolicyWithoutVersionsSerializer < ApplicationSerializer
  has_many :risks, serializer: RiskSerializer
  attributes :id,
             :name,
             :created_at,
             :updated_at,
             :position,
             :description,
             :src_id,
             :status,
             :sections,
             :archived,
             :reminders,
             :published_by

  def status
    return 'published' if object.untouched && object.versions.present?
    'draft'
  end
end
