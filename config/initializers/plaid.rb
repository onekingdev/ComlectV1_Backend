# frozen_string_literal: true

Plaid.config do |p|
  p.client_id = ENV.fetch('PLAID_CLIENT_ID')
  p.secret = ENV.fetch('PLAID_SECRET')
  p.env = ENV['PLAID_ENV'] == 'production' ? :production : :tartan
end
