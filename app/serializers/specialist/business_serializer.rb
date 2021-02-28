# frozen_string_literal: true

class Specialist::BusinessSerializer < ApplicationSerializer
  attributes :id, :business_name, :employees, :country, :city, :state, :description
end
