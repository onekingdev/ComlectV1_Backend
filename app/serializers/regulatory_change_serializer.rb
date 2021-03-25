# frozen_string_literal: true

class RegulatoryChangeSerializer < ApplicationSerializer
  attributes :id,
             :annual_report_id,
             :change,
             :created_at,
             :updated_at
end
