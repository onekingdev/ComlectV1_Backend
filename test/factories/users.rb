# frozen_string_literal: true
FactoryGirl.define do
  factory :user do
    transient do
      email_prefix 'user'
    end

    sequence(:email) { |n| "#{n + rand(10_000)}@example.com" }
    password "password"

    before(:create) do |user, evaluator|
      user.email = "#{evaluator.email_prefix}#{user.email}"
    end
  end
end
