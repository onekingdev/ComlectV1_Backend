# frozen_string_literal: true

FactoryGirl.define do
  factory :stripe_account do
    specialist nil
    external_account 'MyString'
  end
end
