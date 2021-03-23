# frozen_string_literal: true

class ExamRequestSerializer < ApplicationSerializer
  has_many :exam_request_files, serializer: ExamRequestFileSerializer
  attributes :id,
             :name,
             :details,
             :text_items,
             :complete,
             :shared,
             :exam_request_files
end
