# frozen_string_literal: true

class Specialist::JobApplicationSerializer < ApplicationSerializer
  attributes :id,
             :specialist_id,
             :project_id,
             :message,
             :created_at,
             :updated_at,
             :key_deliverables,
             :pricing_type,
             :payment_schedule,
             :fixed_budget,
             :hourly_rate,
             :estimated_hours,
             :starts_on,
             :ends_on,
             :status,
             :role_details,
             :specialist,
             :project,
             :attachment,
             :visibility
  def attachment
    return nil unless object.document
    {
      name: object.document.metadata['filename'],
      url: object.document_url
    }
  end
end
