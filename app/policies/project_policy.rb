# frozen_string_literal: true
class ProjectPolicy < ApplicationPolicy
  def view_full_business?
    business_policy.full_view? || record.specialist == user
  end

  def public_business_info(attribute)
    return record.business[attribute] if view_full_business?
    business_policy.public_info attribute
  end

  def update?
    owner? && record.job_applications.empty?
  end

  def destroy?
    owner?
  end

  def owner?
    record.business.user_id == user.id
  end

  class Scope < Scope
    def resolve
      user ? scope.accessible_by(user) : scope.published.pending
    end
  end

  private

  def business_policy
    @business_policy ||= BusinessPolicy.new(user, record.business)
  end
end
