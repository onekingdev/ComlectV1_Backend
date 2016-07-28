# frozen_string_literal: true
class SpecialistPolicy < ApplicationPolicy
  def update?
    owner?
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
