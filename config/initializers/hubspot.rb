# frozen_string_literal: true

Hubspot.configure(hapikey: ENV['HUBSPOT_API_KEY']) if ENV['HUBSPOT_API_KEY'].present?
