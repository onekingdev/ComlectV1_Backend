# frozen_string_literal: true

class RegulatoryChangeSerializer < ApplicationSerializer
  attributes :id,
             :annual_report_id,
             :change,
             :response,
             :created_at,
             :updated_at
end
