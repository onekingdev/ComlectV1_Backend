# frozen_string_literal: true

class ReviewCategorySerializer < ApplicationSerializer
  attributes :id,
             :annual_report_id,
             :complete,
             :name,
             :review_topics,
             :created_at,
             :updated_at,
             :reminders
end
