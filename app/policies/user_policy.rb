# frozen_string_literal: true
class UserPolicy < ApplicationPolicy
  def toggle_suspend?
    user.is_a?(AdminUser)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
