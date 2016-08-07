# frozen_string_literal: true
FactoryGirl.define do
  factory :project_invite do
    project nil
    specialist nil
    message "MyString"
    status "MyString"
  end
end
