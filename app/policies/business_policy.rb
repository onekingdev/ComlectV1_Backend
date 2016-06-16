# frozen_string_literal: true
class BusinessPolicy < ApplicationPolicy
  PRIVATE_ATTRIBUTES = %i(business_name logo website linkedin_link).freeze

  def public_info(attribute)
    PRIVATE_ATTRIBUTES.include?(attribute) && record.anonymous? ? nil : record.public_send(attribute)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
