# frozen_string_literal: true

class AnnualReviewEmployeeSerializer < ApplicationSerializer
  attributes :id,
             :name,
             :title,
             :department,
             :annual_report_id
end
