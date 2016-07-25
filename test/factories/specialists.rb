# frozen_string_literal: true
FactoryGirl.define do
  factory :specialist do
    first_name "MyString"
    last_name "MyString"
    country "MyString"
    state "MyString"
    city "MyString"
    zip_code "MyString"
    phone "MyString"
    linkedin_link "MyString"
    former_regulator false
    certifications "MyString"
    photo "MyText"
    resume "MyText"
    visibility "MyString"
  end
end
