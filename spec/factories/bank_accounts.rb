# frozen_string_literal: true

FactoryGirl.define do
  factory :bank_account do
    country "MyString"
    currency "MyString"
    routing_number "MyString"
    account_number "MyString"
  end
end
