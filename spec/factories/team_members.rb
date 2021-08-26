# frozen_string_literal: true

FactoryBot.define do
  factory :team_member do
    team_id nil
    first_name 'Team'
    last_name 'Member'
    email 'team@member.com'
  end

  factory :full_team_member, parent: :team_member do
    # Business.first and Subscription.first
    # created with :business_with_subscription

    team { Business.first.team }

    after(:create) do |team_member|
      seat = create(
        :seat,
        business: Business.first,
        subscription: Subscription.first
      )

      create(
        :specialist_invitation,
        team_id: team_member.team_id,
        team_member_id: team_member.id
      )

      seat.assign_to(team_member.id)
    end
  end

  factory :team_member_specialist, parent: :full_team_member do
    after(:create) do |team_member|
      specialist = create(:specialist, team_id: team_member.team_id)
      team_member.specialist_invitation.update(specialist_id: specialist.id)
    end
  end
end
