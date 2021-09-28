# frozen_string_literal: true

class ExamRequestSerializer < ApplicationSerializer
  include RemindersFetcher
  has_many :exam_request_files, serializer: ExamRequestFileSerializer
  attributes :id,
             :name,
             :details,
             :text_items,
             :complete,
             :shared,
             :reminders,
             :exam_request_files

  def reminders
    tasks_for_object(object)
  end
end
