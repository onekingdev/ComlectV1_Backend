# frozen_string_literal: true

class AnnualReportSerializer < ApplicationSerializer
  has_many :review_categories, serializer: ReviewCategorySerializer
  has_many :annual_review_employees, serializer: AnnualReviewEmployeeSerializer
  has_many :regulatory_changes, serializer: RegulatoryChangeSerializer

  attributes :id,
             :exam_start,
             :exam_end,
             :review_start,
             :review_end,
             :created_at,
             :updated_at,
             :business_id,
             :pdf_url,
             :year,
             :name,
             :material_business_changes,
             :review_categories,
             :annual_review_employees,
             :regulatory_changes,
             :reminders
end
