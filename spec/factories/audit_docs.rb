# frozen_string_literal: true

FactoryBot.define do
  factory :audit_doc do
    pdf_data ''
    file_data ''
    audit_request_id 1
    business_id 1
  end
end
