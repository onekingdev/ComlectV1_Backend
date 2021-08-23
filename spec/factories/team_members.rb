# frozen_string_literal: true

FactoryBot.define do
  factory :team_member do
    team_id nil
    first_name 'Team'
    last_name 'Member'
    email 'team@member.com'
  end
end
