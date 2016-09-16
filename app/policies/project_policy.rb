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
    owner? && record.job_applications.empty? || (user.is_a?(AdminUser) && admin_can_update?)
  end

  def admin_can_update?
    (!record.active? && !record.complete?) || admin_is_assigned_to_project?
  end

  def admin_is_assigned_to_project?
    record.issues.open.where(admin_user: user).any?
  end

  def destroy?
    owner?
  end

  def postable?
    owner? && (record.draft? || record.review?)
  end

  def post?
    postable? && user.payment_info?
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
