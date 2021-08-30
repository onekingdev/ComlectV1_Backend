# frozen_string_literal: true

class Specialist::RoleSerializer < ApplicationSerializer
  attributes :business_name, :role, :business_id, :plan

  def business_name
    object.business.name
  end

  def plan
    object.business.plan
  end
end
