# frozen_string_literal: true

unless AdminUser.any?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end

%w(USA Canada Africa Central\ America Asia South\ America Australasia Europe).each do |name|
  Jurisdiction.find_or_create_by! name: name
end

%w(Broker-Dealer Banking Fund\ Manager Investment\ Adviser Commodities\ Trader).each do |name|
  Industry.find_or_create_by! name: name
end
