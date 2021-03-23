# frozen_string_literal: true

class ExamRequestFileSerializer < ApplicationSerializer
  attributes :id,
             :exam_request_id,
             :file_url,
             :name,
             :created_at,
             :updated_at
end
