# frozen_string_literal: true

class BusinessPolicy < ApplicationPolicy
  PRIVATE_ATTRIBUTES = %i[business_name logo website linkedin_link].freeze

  def public_info(attribute)
    return record.public_send(attribute) if full_view?
    PRIVATE_ATTRIBUTES.include?(attribute) && record.anonymous? ? nil : record.public_send(attribute)
  end

  def full_view?
    record.public? || owner?
  end

  def update?
    owner? || user.is_a?(AdminUser)
  end

  def freeze?
    record.projects.active.empty?
  end

  def owner?
    user && record.user_id == user.id
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
