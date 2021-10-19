# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    association :user, email_prefix: 'business'
    # association :rewards_tier
    contact_first_name { Faker::Name.first_name }
    contact_last_name { Faker::Name.last_name }
    contact_email { Faker::Internet.email }
    business_name { Faker::Company.name }
    industries { [create(:industry)] }
    employees { Business::EMPLOYEE_OPTIONS.sample }
    risk_tolerance { Business::RISK_TOLERANCE_OPTIONS.sample }
    description { Faker::Company.bs }
    country { Faker::Address.country }
    city { Faker::Address.city }
    state { Faker::Address.state }
    time_zone 'Mountain Time (US & Canada)'
    client_account_cnt 123
    total_assets '20MM'

    sequence(:username) { |n| "UserN#{n + rand(10_000)}" }
    trait :with_payment_profile do
      after(:create) do |business|
        PaymentProfile.skip_callback(:create, :before, :create_stripe_customer)
        create(:payment_profile_with_source, business: business)
        PaymentProfile.set_callback(:create, :before, :create_stripe_customer)
      end
    end

    trait :with_payment_profile_bank do
      after(:create) do |business|
        PaymentProfile.skip_callback(:create, :before, :create_stripe_customer)
        profile = create(:payment_profile_with_source, business: business)
        PaymentProfile.set_callback(:create, :before, :create_stripe_customer)

        profile.payment_sources.first.update(
          type: 'PaymentSource::Ach',
          brand: 'Chase',
          validated: true,
          primary: true
        )
      end
    end

    trait :credit do
      credits_in_cents 3000
    end

    trait :fee_free do
      fee_free true
    end
  end

  factory :business_with_payment_profile, parent: :business do
    after(:create) do |business|
      PaymentProfile.skip_callback(:create, :before, :create_stripe_customer)
      profile = create(:payment_profile_with_source, business: business)
      PaymentProfile.set_callback(:create, :before, :create_stripe_customer)

      profile.payment_sources.first.update(
        primary: true,
        brand: 'Visa',
        last4: '4242',
        exp_month: 12,
        exp_year: 2022,
        validated: true,
        stripe_id: 'stripe_id'
      )
    end
  end

  factory :business_with_free_subscription, parent: :business do
    onboarding_passed true

    after(:create) do |business|
      subscription = create(
        :subscription,
        local: true,
        quantity: 1,
        plan: 'free',
        kind_of: :ccc,
        auto_renew: true,
        business_id: business.id,
        title: Subscription::PLAN_NAMES['free']
      )

      Seat.create(
        business_id: business.id,
        subscribed_at: Time.now.utc,
        subscription_id: subscription.id
      )

      free_seat = business.available_seat
      owner = business.team_members.where(email: business.user.email).first
      free_seat.assign_to(owner.id)
    end
  end

  factory :business_with_free_subscription_and_payment_profile, parent: :business_with_payment_profile do
    onboarding_passed true

    after(:create) do |business|
      subscription = create(
        :subscription,
        local: true,
        quantity: 1,
        plan: 'free',
        kind_of: :ccc,
        auto_renew: true,
        business_id: business.id,
        title: Subscription::PLAN_NAMES['free']
      )

      Seat.create(
        business_id: business.id,
        subscribed_at: Time.now.utc,
        subscription_id: subscription.id
      )

      free_seat = business.available_seat
      owner = business.team_members.where(email: business.user.email).first
      free_seat.assign_to(owner.id)
    end
  end

  factory :business_with_subscription, parent: :business do
    after(:create) do |business|
      PaymentProfile.skip_callback(:create, :before, :create_stripe_customer)
      profile = create(:payment_profile_with_source, business: business)
      PaymentProfile.set_callback(:create, :before, :create_stripe_customer)

      profile.payment_sources.first.update(
        primary: true,
        brand: 'Chase',
        validated: true,
        type: 'PaymentSource::Ach'
      )

      payment_source = profile.payment_sources.first
      create(
        :subscription,
        quantity: 1,
        kind_of: 'ccc',
        amount: 0.15e6,
        interval: 'year',
        currency: 'usd',
        title: 'Team Plan',
        business: business,
        plan: 'team_tier_annual',
        payment_source: payment_source,
        stripe_subscription_id: 'stripe_sub_id',
        next_payment_date: Time.zone.now + 1.year
      )
    end
  end

  factory :business_with_team_annual_subscription, parent: :business do
    onboarding_passed true

    after(:create) do |business|
      PaymentProfile.skip_callback(:create, :before, :create_stripe_customer)
      profile = create(:payment_profile_with_source, business: business)
      PaymentProfile.set_callback(:create, :before, :create_stripe_customer)

      profile.payment_sources.first.update(
        primary: true,
        brand: 'Visa',
        last4: '4242',
        exp_month: 12,
        exp_year: 2022,
        validated: true,
        stripe_id: 'stripe_id'
      )

      payment_source = profile.payment_sources.first
      create(
        :subscription,
        quantity: 1,
        kind_of: 'ccc',
        amount: 0.15e6,
        interval: 'year',
        currency: 'usd',
        title: 'Team Plan',
        business: business,
        plan: 'team_tier_annual',
        payment_source: payment_source,
        stripe_subscription_id: 'stripe_sub_id',
        next_payment_date: Time.zone.now + 1.year
      )
    end
  end

  factory :team_annual_business_with_one_seat, parent: :business_with_team_annual_subscription do
    after(:create) do |business|
      subscription = business.subscriptions.last

      Seat.create(
        business_id: business.id,
        subscribed_at: Time.now.utc,
        subscription_id: subscription.id
      )

      free_seat = business.available_seat
      owner = business.team_members.where(email: business.user.email).first
      free_seat.assign_to(owner.id)
    end
  end

  factory :business_with_team_seats, parent: :business_with_team_annual_subscription do
    after(:create) do |business|
      subscription = business.subscriptions.last

      Seat::FREE_TEAM_SEAT_COUNT.times do
        Seat.create(
          business_id: business.id,
          subscribed_at: Time.now.utc,
          subscription_id: subscription.id
        )
      end

      free_seat = business.available_seat
      owner = business.team_members.where(email: business.user.email).first
      free_seat.assign_to(owner.id)
    end
  end

  factory :business_with_team_seats_and_employee, parent: :business_with_team_seats do
    after(:create) do |business|
      team = business.team
      team_member = create(:team_member, team: team)
      seat = business.seats.available.first
      seat.assign_to(team_member.id)

      invitation = team_member.create_specialist_invitation(team: team)
      specialist = create(:specialist)
      invitation.accepted!(specialist)
    end
  end

  factory :business_with_team_annual_and_seats_annual_subscriptions, parent: :business_with_team_seats_and_employee do
    after(:create) do |business|
      payment_source = business.payment_profile.default_payment_source

      seat_subscription = create(
        :subscription,
        quantity: 1,
        amount: 0.12e5,
        kind_of: :seats,
        interval: 'year',
        currency: 'usd',
        auto_renew: true,
        plan: 'seats_annual',
        business_id: business.id,
        payment_source: payment_source,
        next_payment_date: Time.zone.now + 1.year,
        title: Subscription::PLAN_NAMES['seats_annual'],
        stripe_subscription_id: 'stripe_seats_annual_subscription_id'
      )

      Seat.create(
        business_id: business.id,
        subscribed_at: Time.now.utc,
        subscription_id: seat_subscription.id
      )
    end
  end

  factory :business_with_team_annual_and_seats_annual_subscriptions_5_seats, parent: :business_with_team_annual_and_seats_annual_subscriptions do
    after(:create) do |business|
      seat_subscription = business.subscriptions.find_by(plan: 'seats_annual')
      seat_subscription.update(quantity: 2)

      Seat.create(
        business_id: business.id,
        subscribed_at: Time.now.utc,
        subscription_id: seat_subscription.id
      )
    end
  end

  factory :business_with_team_monthly_subscription, parent: :business_with_payment_profile do
    onboarding_passed true

    after(:create) do |business|
      payment_source = business.payment_profile.payment_sources.first

      create(
        :subscription,
        quantity: 1,
        kind_of: 'ccc',
        amount: 0.15e6,
        currency: 'usd',
        interval: 'year',
        business: business,
        plan: 'team_tier_monthly',
        payment_source: payment_source,
        stripe_subscription_id: 'stripe_sub_id',
        next_payment_date: Time.zone.now + 1.year,
        title: Subscription::PLAN_NAMES['team_tier_monthly']
      )
    end
  end

  factory :business_with_team_monthly_subscription_and_seats, parent: :business_with_team_monthly_subscription do
    trait :with_default_seats do
      after(:create) do |business|
        subscription = business.subscriptions.last

        Seat::FREE_TEAM_SEAT_COUNT.times do
          Seat.create(
            business_id: business.id,
            subscribed_at: Time.now.utc,
            subscription_id: subscription.id
          )
        end

        free_seat = business.available_seat
        owner = business.team_member
        free_seat.assign_to(owner.id)
      end
    end
  end

  factory :business_with_business_tier_monthly_subscription, parent: :business_with_payment_profile do
    onboarding_passed true

    after(:create) do |business|
      payment_source = business.payment_profile.payment_sources.first

      create(
        :subscription,
        quantity: 1,
        kind_of: 'ccc',
        amount: 0.15e6,
        currency: 'usd',
        interval: 'year',
        business: business,
        plan: 'business_tier_monthly',
        payment_source: payment_source,
        stripe_subscription_id: 'stripe_sub_id',
        next_payment_date: Time.zone.now + 1.year,
        title: Subscription::PLAN_NAMES['business_tier_monthly']
      )
    end
  end

  factory :business_with_business_tier_monthly_subscription_and_seats, parent: :business_with_business_tier_monthly_subscription do
    trait :with_default_seats do
      after(:create) do |business|
        subscription = business.subscriptions.last

        Seat::FREE_BUSINESS_SEAT_COUNT.times do
          Seat.create(
            business_id: business.id,
            subscribed_at: Time.now.utc,
            subscription_id: subscription.id
          )
        end

        free_seat = business.available_seat
        owner = business.team_member
        free_seat.assign_to(owner.id)
      end
    end
  end

  factory :business_with_business_tier_annual_subscription, parent: :business_with_payment_profile do
    onboarding_passed true

    after(:create) do |business|
      payment_source = business.payment_profile.payment_sources.first

      create(
        :subscription,
        quantity: 1,
        kind_of: 'ccc',
        amount: 0.15e6,
        currency: 'usd',
        interval: 'year',
        business: business,
        plan: 'business_tier_annual',
        payment_source: payment_source,
        stripe_subscription_id: 'stripe_sub_id',
        next_payment_date: Time.zone.now + 1.year,
        title: Subscription::PLAN_NAMES['business_tier_annual']
      )
    end
  end

  factory :business_with_business_tier_annual_subscription_and_seats, parent: :business_with_business_tier_annual_subscription do
    trait :with_default_seats do
      after(:create) do |business|
        subscription = business.subscriptions.last

        Seat::FREE_BUSINESS_SEAT_COUNT.times do
          Seat.create(
            business_id: business.id,
            subscribed_at: Time.now.utc,
            subscription_id: subscription.id
          )
        end

        free_seat = business.available_seat
        owner = business.team_member
        free_seat.assign_to(owner.id)
      end
    end
  end
end
