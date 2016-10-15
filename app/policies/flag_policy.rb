# frozen_string_literal: true
class FlagPolicy < ApplicationPolicy
  def update?
    false
  end

  def destroy?
    false
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
