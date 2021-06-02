# frozen_string_literal: true

class BusinessSerializer < ApplicationSerializer
  attributes :id,
             :contact_first_name,
             :contact_last_name,
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
             :client_account_cnt,
             :address_1,
             :address_2,
             :website,
             :contact_phone,
             :zipcode
  has_many :jurisdictions, serializer: JurisdictionSerializer
  has_many :industries, serializer: IndustrySerializer
end
