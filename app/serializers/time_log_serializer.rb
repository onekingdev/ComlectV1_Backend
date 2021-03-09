# frozen_string_literal: true

class TimeLogSerializer < ApplicationSerializer
  attributes :id,
             :timesheet_id,
             :description,
             :hours,
             :created_at,
             :updated_at,
             :hourly_rate,
             :total_amount,
             :date
end
