# frozen_string_literal: true

FactoryBot.define do
  factory :annual_report do
    exam_start '2019-12-05'
    exam_end '2019-12-05'
    review_start '2019-12-05'
    review_end '2019-12-05'
    employees_interviewed 'MyText'
    business_change 'MyText'
    regulatory_change 'MyText'
    regulatory_response 'MyText'
    cof_bits 'MyString'
    findings 'MyText'
    tailored_lvl 1
    comments 'MyText'
  end
end
