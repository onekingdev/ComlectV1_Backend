# frozen_string_literal: true

class Public::ExamSerializer < ApplicationSerializer
  has_many :exam_requests, serializer: ExamRequestSerializer
  attributes :name,
             :starts_on,
             :ends_on,
             :share_uuid,
             :created_at,
             :updated_at,
             :exam_requests,
             :complete
end
