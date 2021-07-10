# frozen_string_literal: true

class ProjectIssuePolicy < ApplicationPolicy
  def update?
    user.super_admin? || record.admin_user == user
  end

  def destroy?
    user.super_admin?
  end
end
