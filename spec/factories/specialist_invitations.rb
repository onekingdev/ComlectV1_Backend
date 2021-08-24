# frozen_string_literal: true

FactoryBot.define do
  factory :specialist_invitation, class: Specialist::Invitation do
    team_id nil
    team_member_id nil
  end
end
