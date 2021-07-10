# frozen_string_literal: true

class Business::JobApplicationSerializer < ApplicationSerializer
  has_one :specialist, serializer: Business::SpecialistSerializer
  has_one :project, serializer: ProjectSerializer
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
             :visibility
end
