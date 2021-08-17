# frozen_string_literal: true

# rubocop:disable Rails/Output
unless AdminUser.any?
  AdminUser.create!(
    email: 'admin@complect.com',
    password: 'password',
    password_confirmation: 'password',
    super_admin: true
  )
  puts 'Admin credentials: admin@complect.com / password (login and change it)'
end
# rubocop:enable Rails/Output

%w[USA Canada Africa Central\ America Asia South\ America Australia Europe].each do |name|
  Jurisdiction.find_or_create_by! name: name
end

industries = {
  'Broker-Dealer' => {
    'sub_industries' => "Broker Rep\r\nFunding Portal\r\nCapital Acquisition Broker\r\nLimited Purpose Broker Dealer\r\nBroker Dealer\r\nAlternative Trading System/Exchange",
    'sub_industries_specialist' => "Funding portals\r\nATS/Exchanges\r\nLimited purpose broker dealers\r\nCapital acquisition brokers\r\nBroker dealers\r\nAML/KYC (Broker Dealer)"
  },
  'Banking' => {},
  'Fund Manager' => {},
  'Investment Adviser' => {
    'sub_industries' => "Provide advice to separately managed accounts (e.g. individuals)\r\nProvide advice to mutual funds\r\nProvide advice to hedge funds\r\nProvide advice to private equity funds\r\nProvide advice to venture capital funds\r\nProvide advice to ERISA accounts\r\nProvide advice to Taft-Hartley accounts\r\nProvide advice to municipalities or on municipal securities",
    'sub_industries_specialist' => "ERISA\r\nGIPS\r\nMutual funds\r\nBusiness development corporations\r\nPrivate equity funds\r\nHedge funds\r\nVenture capital funds\r\nMunicipal advisors\r\nFinancial Planners"
  },
  'Commodities Trader' => {},
  'Family Office' => {},
  'Pension Plan' => {},
  'Other' => {}
}

industries.each do |key, val|
  industry = Industry.find_or_initialize_by(name: key)

  if val.present?
    industry.sub_industries = val['sub_industries']
    industry.sub_industries_specialist = val['sub_industries_specialist']
  end

  industry.save!
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
