# frozen_string_literal: true

# rubocop:disable Rails/Output
if Business.where(discourse_username: ENV.fetch('DISCOURSE_BUSINESS_API_USER')).empty?
  user = User.create!(
    email: 'businessforum@complect.co',
    password: 'password',
    password_confirmation: 'password'
  )
  user.create_business!(
    anonymous: true,
    contact_first_name: 'Business',
    contact_last_name: 'Admin',
    contact_email: user.email,
    business_name: 'Business Admin',
    industries: Industry.all,
    employees: Business::EMPLOYEE_OPTIONS.first,
    description: 'Discourse Admin',
    country: 'United States',
    city: 'New York',
    state: 'NY',
    time_zone: 'Eastern Time (US & Canada)',
    discourse_username: ENV.fetch('DISCOURSE_BUSINESS_API_USER')
  )
  puts "Discourse Business Admin ID / password: #{user.business.id} / password (login and change it)"
end

if Specialist.where(discourse_username: ENV.fetch('DISCOURSE_SPECIALIST_API_USER')).empty?
  user = User.create!(
    email: 'specialistforum@complect.co',
    password: 'password',
    password_confirmation: 'password'
  )
  user.create_specialist!(
    visibility: Specialist.visibilities[:is_private],
    discourse_username: ENV.fetch('DISCOURSE_SPECIALIST_API_USER'),
    first_name: 'Specialist',
    last_name: 'Admin'
  )
  puts "Discourse Specialist Admin ID / password: #{user.specialist.id} / password (login and change it)"
end
