# frozen_string_literal: true

class ReviewCategorySerializer < ApplicationSerializer
  include RemindersFetcher
  attributes :id,
             :annual_report_id,
             :complete,
             :name,
             :review_topics,
             :created_at,
             :updated_at,
             :reminders

  def reminders
    tasks_for_object(object)
  end
end
