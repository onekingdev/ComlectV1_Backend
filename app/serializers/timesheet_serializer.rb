class TimesheetSerializer < ApplicationSerializer
  has_many :time_logs, serializer: TimeLogSerializer
  attributes :id,
             :project_id,
             :status,
             :created_at,
             :updated_at,
             :status_changed_at,
             :first_submitted_at,
             :expires_at,
             :last_submitted_at
end
