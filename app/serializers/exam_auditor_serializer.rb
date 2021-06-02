# frozen_string_literal: true

class ExamAuditorSerializer < ApplicationSerializer
  attributes :id,
             :exam_id,
             :email
end
