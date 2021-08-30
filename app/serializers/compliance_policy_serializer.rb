# frozen_string_literal: true

class CompliancePolicySerializer < ApplicationSerializer
  has_many :versions, serializer: CompliancePolicySerializer
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
             :versions,
             :archived,
             :reminders

  def status
    return 'published' if object.untouched && object.versions.present?
    'draft'
  end
end
