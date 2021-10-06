# frozen_string_literal: true

class Specialist::BusinessSerializer < ApplicationSerializer
  attributes :id, :business_name, :employees, :country, :city, :state, :description, :jurisdictions, :industries, :logo, :aum, :client_account_cnt, :active_member, :ratings_average, :ratings_count, :ratings_total
  has_many :jurisdictions, serializer: JurisdictionSerializer
  has_many :industries, serializer: IndustrySerializer

  def logo
    object.logo_url(:thumb)
  end

  def active_member
    object.team_members.where(active: true).size
  end
end
