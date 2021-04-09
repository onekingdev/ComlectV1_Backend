# frozen_string_literal: true

class CompliancePolicyConfigurationSerializer < ApplicationSerializer
  attributes :logo_data,
             :address,
             :phone,
             :email,
             :disclosure,
             :body
end
