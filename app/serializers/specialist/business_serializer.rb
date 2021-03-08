# frozen_string_literal: true

class Specialist::BusinessSerializer < ApplicationSerializer
  attributes :id, :business_name, :employees, :country, :city, :state, :description, :jurisdictions, :industries, :logo
  has_many :jurisdictions, serializer: JurisdictionSerializer
  has_many :industries, serializer: IndustrySerializer

  def logo
    object.logo_url(:thumb)
  end
end
