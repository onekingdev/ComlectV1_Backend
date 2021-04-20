# frozen_string_literal: true

class BusinessSerializer < ApplicationSerializer
  attributes :id,
             :business_name,
             :city,
             :state,
             :jurisdictions,
             :industries,
             :crd_number,
             :sub_industries,
             :username,
             :aum,
             :apartment,
             :client_account_cnt
  has_many :jurisdictions, serializer: JurisdictionSerializer
  has_many :industries, serializer: IndustrySerializer
end
