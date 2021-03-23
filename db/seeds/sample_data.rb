# frozen_string_literal: true

industry_ids = Industry.pluck(:id)
jurisdiction_ids = Jurisdiction.pluck(:id)
business_ids = []
ActiveRecord::Base.transaction do
  500.times do |i|
    email = "complecttest+b#{i + 1}@gmail.com"
    user = User.create! email: email,
                        password: 'password',
                        password_confirmation: 'password'
    business = user.create_business! contact_first_name: Faker::Name.first_name,
                                     contact_last_name: Faker::Name.last_name,
                                     contact_email: email,
                                     business_name: Faker::Company.name,
                                     employees: Business::EMPLOYEE_OPTIONS.sample,
                                     description: Faker::Company.catch_phrase,
                                     industry_ids: industry_ids.sample(rand(industry_ids.size) + 1),
                                     country: 'US',
                                     city: Faker::Address.city,
                                     state: Faker::Address.state,
                                     time_zone: Faker::Address.time_zone,
                                     address_1: Faker::Address.street_address,
                                     zipcode: Faker::Address.zip_code,
                                     anonymous: rand(2) == 1
    business_ids << business.id
  end

  specialist_ids = []
  500.times do |i|
    email = "complecttest+s#{i + 1}@gmail.com"
    user = User.create! email: email,
                        password: 'password',
                        password_confirmation: 'password'
    specialist = Specialist.create!(
      user: user,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      country: 'US',
      state: Faker::Address.state,
      city: Faker::Address.city,
      zipcode: Faker::Address.zip_code,
      time_zone: Faker::Address.time_zone,
      former_regulator: rand(2) == 1,
      visibility: Specialist.visibilities.values.sample,
      lat: Faker::Address.latitude,
      lng: Faker::Address.longitude,
      industry_ids: industry_ids.sample(rand(industry_ids.size) + 1),
      jurisdiction_ids: jurisdiction_ids.sample(rand(jurisdiction_ids.size) + 1),
      years_of_experience: 8
    )
    specialist_ids << specialist.id
  end

  100.times do |_i|
    full_time = rand(2) == 1
    title = "#{Faker::Company.industry} #{full_time ? 'Job' : 'Project'}"
    starts_on = rand(30..329).days.from_now
    full_time_fields = { annual_salary: rand(50_000..119_999) }
    one_time_fields = {
      key_deliverables: 'Deliverable 1, Deliverable 2',
      ends_on: starts_on + rand(14..103).days,
      location_type: 'remote',
      payment_schedule: Project.payment_schedules.values.sample,
      estimated_hours: rand(50..149),
      hourly_rate: rand(30..129)
    }
    status = Project.statuses.values.sample
    specialist_id = specialist_ids.sample if status == 'complete'
    specialist_id ||= specialist_ids.sample if status == 'published' && rand(2) == 1
    Project.create!({
      business_id: business_ids.sample,
      type: full_time ? 'full_time' : 'one_off',
      status: status,
      specialist_id: specialist_id,
      title: title,
      location_type: 'remote',
      jurisdiction_ids: jurisdiction_ids.sample(rand(jurisdiction_ids.size) + 1),
      industry_ids: industry_ids.sample(rand(industry_ids.size) + 1),
      starts_on: starts_on,
      description: Faker::Lorem.paragraph
    }.merge(full_time ? full_time_fields : one_time_fields))
  end
end
