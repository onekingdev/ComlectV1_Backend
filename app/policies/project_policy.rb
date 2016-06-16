# frozen_string_literal: true
class ProjectPolicy < ApplicationPolicy
  def update?
    owner? # TODO: && record.applicants.empty?
  end

  def destroy?
    owner?
  end

  def owner?
    record.business.user_id == user.id
  end

  class Scope < Scope
    def resolve
      user ? scope.accessible_by(user) : scope.published
    end
  end
end
