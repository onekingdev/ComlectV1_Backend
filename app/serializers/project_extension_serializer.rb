# frozen_string_literal: true

class ProjectExtensionSerializer < ApplicationSerializer
  attributes :id,
             :project_id,
             :requester,
             :ends_on,
             :expires_at,
             :status,
             :requester,
             :starts_on,
             :fixed_budget,
             :hourly_rate,
             :role_details,
             :key_deliverables
end
