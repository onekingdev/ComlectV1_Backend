# frozen_string_literal: true
FactoryGirl.define do
  factory :work_experience do
    specialist nil
    company "MyString"
    job_title "MyString"
    location "MyString"
    from "2016-07-20"
    to "2016-07-20"
    current false
    compliance false
    description "MyString"
  end
end
