# frozen_string_literal: true

class Admin::UserPolicy < AdminPolicy
  def update?
    true
  end

  def destroy?
    true
  end

  def impersonate?
    true
  end

  def stop_impersonating?
    true
  end

  def toggle_suspend?
    true
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
