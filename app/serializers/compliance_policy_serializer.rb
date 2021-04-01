# frozen_string_literal: true

class CompliancePolicySerializer < ApplicationSerializer
  has_many :versions, serializer: CompliancePolicySerializer
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
             :archived
end
