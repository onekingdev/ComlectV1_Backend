# frozen_string_literal: true

class CompliancePolicyConfigurationSerializer < ApplicationSerializer
  attributes :logo,
             :address,
             :phone,
             :email,
             :disclosure,
             :body

  def logo
    object.logo_url(:original)
  end
end
