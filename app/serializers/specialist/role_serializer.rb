# frozen_string_literal: true

class Specialist::RoleSerializer < ApplicationSerializer
  attributes :business_name, :role, :business_id

  def business_name
    object.business.name
  end
end
