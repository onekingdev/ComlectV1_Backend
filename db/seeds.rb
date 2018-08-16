# frozen_string_literal: true

# rubocop:disable Rails/Output
unless AdminUser.any?
  AdminUser.create!(
    email: 'admin@complect.co',
    password: 'password',
    password_confirmation: 'password',
    super_admin: true
  )
  puts 'Admin credentials: admin@complect.co / password (login and change it)'
end
# rubocop:enable Rails/Output

%w[USA Canada Africa Central\ America Asia South\ America Australia Europe].each do |name|
  Jurisdiction.find_or_create_by! name: name
end

%w[Broker-Dealer Banking Fund\ Manager Investment\ Adviser
   Commodities\ Trader Family\ Office Pension\ Plan Other].each do |name|
  Industry.find_or_create_by! name: name
end

%w[sec finra cfdc nfa volckerrule doddfrank ria privateequity hedgefund mutualfund
   investmentcompany investmentcompanyact investmentadvisersact].each do |name|
  Skill.find_or_create_by! name: "##{name}"
end

[{ name: 'None', fee: 0.10, amount: (0...9999) },
 { name: 'Gold', fee: 0.08, amount: (10_000...50_000) },
 { name: 'Platinum', fee: 0.07, amount: (50_001...100_000) },
 { name: 'Platinum Honors', fee: 0.06, amount: (100_001...1_000_000_000) }].each do |tier|
  record = RewardsTier.find_by(name: tier[:name])
  RewardsTier.create(name: tier[:name], fee_percentage: tier[:fee], amount: tier[:amount]) unless record
end

load Rails.root.join('db', 'seeds', 'sample_data.rb') if ENV['SAMPLE_DATA']
