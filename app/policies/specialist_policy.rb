# frozen_string_literal: true
class SpecialistPolicy < ApplicationPolicy
  def update?
    owner? || user.is_a?(AdminUser)
  end

  def owner?
    user && record.user_id == user.id
  end

  def freeze?
    record.projects.active.empty?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
