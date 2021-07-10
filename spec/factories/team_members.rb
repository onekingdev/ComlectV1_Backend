# frozen_string_literal: true

FactoryBot.define do
  factory :team_member do
    team_id 1
    name 'MyString'
    first_name 'Alex'
    last_name 'Petrov'
    department 'MyString'
    email 'MyString'
  end
end
