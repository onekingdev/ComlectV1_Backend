# frozen_string_literal: true

class Settings::GeneralSerializer < ApplicationSerializer
  attributes :country,
             :city,
             :state,
             :time_zone,
             :contact_phone
end
