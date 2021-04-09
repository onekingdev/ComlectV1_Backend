# frozen_string_literal: true

class CompliancePolicyConfiguration < ApplicationRecord
  belongs_to :business
  include ImageUploader[:logo]

  def self.create_default(business_id)
    create(business_id: business_id, address: true, phone: true, email: true, disclosure: true, body: '')
  end
end
